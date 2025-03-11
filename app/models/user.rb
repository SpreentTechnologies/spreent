class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable

  has_one_attached :avatar do |attachable|
    attachable.variant :circle, resize_to_limit: [300, 300]
  end

  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy
  has_many :notifications, as: :recipient

  has_many :conversation_participants
  has_many :conversations, through: :conversation_participants
  has_many :messages

  # Follower associations
  has_many :active_follows, class_name: "Follow",
           foreign_key: "follower_id",
           dependent: :destroy

  has_many :following, through: :active_follows, source: :followed


  # Followed associations
  has_many :passive_follows, class_name: "Follow",
           foreign_key: "followed_id",
           dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

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

  validates :avatar, presence: true, on: :update

  has_many :liked_posts, through: :likes, source: :post
  has_many :reports
end
