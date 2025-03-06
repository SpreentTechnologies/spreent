class MessagesController < ApplicationController
  before_action :set_conversation

  def create
    @message = @conversation.messages.new(message_params)
    @message.user = current_user
    @message.read = false

    respond_to do |format|
      if @message.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("messages",
                                partial: "messages/message",
                                locals: { message: @message, current_user_for_view: current_user }),
            turbo_stream.replace("new_message",
                                 partial: "messages/form",
                                 locals: { conversation: @conversation, message: Message.new })
          ]
        end
        format.html { redirect_to conversation_path(@conversation) }
      else
        format.html { render "conversations/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end