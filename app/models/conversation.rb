class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipient_id }

  scope :between, -> (sender_id, recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id = ?) OR (conversations.sender_id = ? AND conversations.recipient_id = ?)",
          sender_id, recipient_id, recipient_id, sender_id)
  end

  def opposed_user(user)
    user.id == sender_id ? recipient : sender
  end

  def last_message
    messages.order(created_at: :desc).first
  end

  def latest_message
    messages.order(created_at: :desc).first
  end

  def unread_count_for(user)
    messages.where(read: false).where.not(user: user).count
  end

  def mark_as_read_for(user)
    messages.where.not(user: user).update_all(read: true)
  end

  def other_participants(current_user)
    users.where.not(id: current_user.id)
  end
end
