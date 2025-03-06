# app/channels/webrtc_channel.rb
class WebrtcChannel < ApplicationCable::Channel
  def subscribed
    stream_from "webrtc_#{params[:call_id]}"
  end

  def unsubscribed
    # Any cleanup needed
  end

  # Handle ICE candidates
  def ice_candidate(data)
    call_id = data['call_id']
    ActionCable.server.broadcast("webrtc_#{call_id}", {
      type: 'ice_candidate',
      candidate: data['candidate'],
      sender_id: current_user.id
    })
  end

  # Handle session description (offer and answer)
  def session_description(data)
    call_id = data['call_id']
    ActionCable.server.broadcast("webrtc_#{call_id}", {
      type: 'session_description',
      description: data['description'],
      sender_id: current_user.id
    })
  end
end