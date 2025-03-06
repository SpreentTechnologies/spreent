class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :body, presence: true
  after_create_commit -> { broadcast_message }

  def broadcast_message
    # Broadcast to the conversation stream
    broadcast_append_to "conversation_#{conversation.id}",
                        target: "messages",
                        partial: "messages/message",
                        locals: { message: self, current_user_for_view: self.user }

    # Update the conversation preview in the conversations list for all participants
    conversation.users.each do |user|
      broadcast_replace_to "user_#{user.id}_conversations",
                           target: "conversation_#{conversation.id}_preview",
                           partial: "conversations/conversation_preview",
                           locals: { conversation: conversation, current_user_for_view: user }
    end
    end
end
