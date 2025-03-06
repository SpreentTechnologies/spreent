class Conversation < ApplicationRecord
  has_many :conversation_participants, dependent: :destroy
  has_many :users, through: :conversation_participants
  has_many :messages, dependent: :destroy

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
