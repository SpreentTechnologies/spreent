class ConversationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversation_channel_#{params[:conversation_id]}"
  end

  def unsubscribed
    stop_all_streams
  end

  def send_message(data)
    Message.create!(
      conversation_id: params[:conversation_id],
      user_id: params[:user_id],
      content: data["message"],
      message_type: data["message_type"],
    )
  end
end