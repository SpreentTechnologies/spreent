class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :body, presence: true
  after_create_commit :broadcast_message

  private

  def broadcast_message
    ActionCable.server.broadcast(
      "conversation_channel_#{conversation.id}",
      {
        message: ApplicationController.render(
          partial: 'messages/message',
          locals: { message: self, current_user: user }
        ),
        conversation_id: conversation.id
      }
    )
  end
end
