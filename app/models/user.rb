class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
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
