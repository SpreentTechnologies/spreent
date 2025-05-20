class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable, :omniauthable, 
         :omniauth_providers => [:apple, :google_oauth2]

  has_one_attached :avatar do |attachable|
    attachable.variant :circle, resize_to_limit: [300, 300]
  end

  has_many :memberships
  validates :name, presence: true

  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :notifications, as: :recipient
  has_many :communities, through: :memberships

  has_many :messages
  has_many :conversations_as_sender, class_name: 'Conversation', foreign_key: 'sender_id'
  has_many :conversations_as_recipient, class_name: 'Conversation', foreign_key: 'recipient_id'

  # Follower associations
  has_many :active_follows, class_name: 'Follow',
           foreign_key: 'follower_id',
           dependent: :destroy
  # Passive relationships (user being followed by others)
  has_many :passive_follows, class_name: 'Follow',
           foreign_key: 'followed_id',
           dependent: :destroy

  # Users that this user is following
  has_many :following, through: :active_follows, source: :followed, class_name: 'User'
  # Users that follow this user
  has_many :followers, through: :passive_follows, source: :follower, class_name: 'User'

  has_many :participations
  has_many :challenges, through: :participations

  def conversations
    Conversation.where("sender_id = ? OR recipient_id = ?", self.id, self.id)
  end

  def unread_messages_count
    Message.joins(:conversation)
           .where("conversations.sender_id = ? OR conversations.recipient_id = ?", self.id, self.id)
           .where.not(user_id: self.id)
           .where(read: false)
           .count
  end


  # Follow methods
  def follow(other_user)
    following << other_user unless self == other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def participating_in?(challenge)
    challenges.include?(challenge)
  end

  def initials
    name.split.map(&:first).join.upcase
  end

  def owns?(community)
    self.id == community.admin_id
  end

  def conversations_with(other_user)
    Conversation.joins(:conversation_participants)
                .where(conversation_participants: { user_id: other_user.id })
                .joins("INNER JOIN conversation_participants AS my_cp ON my_cp.conversation_id = conversations.id")
                .where(my_cp: { user_id: self.id })
                .distinct
  end

  # Find or create a direct conversation with another user
  def start_conversation_with(other_user, title = nil)
    # Check if a conversation already exists
    existing = conversations_with(other_user).first
    return existing if existing.present?

    # Create a new conversation
    conversation = Conversation.create(title: title || "#{self.name} and #{other_user.name}")

    # Add both users to the conversation
    conversation.users << self
    conversation.users << other_user

    conversation
  end

  attr_accessor :invitation_code

  has_many :liked_posts, through: :likes, source: :post
  has_many :reports

  def member_of?(community)
    communities.include?(community)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name if auth.info.name.present?
      user.avatar.attach(io: URI.parse(auth.info.image).open, filename: "#{auth.uid}.jpg") if auth.info.image.present?

      # Store extra info.
  end
end
