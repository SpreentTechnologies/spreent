# app/controllers/calls_controller.rb
class CallsController < ApplicationController
  before_action :authenticate_user!

  def create
    recipient = User.find(params[:recipient_id])
    call = Call.create!(
      caller: current_user,
      recipient: recipient,
      status: 'pending'
    )

    # Broadcast to recipient that they're receiving a call
    Turbo::StreamsChannel.broadcast_replace_to(
      "user_#{recipient.id}",
      target: "incoming_calls",
      partial: "calls/incoming_call",
      locals: { call: call }
    )

    render turbo_stream: turbo_stream.replace(
      "outgoing_call",
      partial: "calls/outgoing_call",
      locals: { call: call }
    )
  end

  def accept
    call = Call.find_by(uuid: params[:id])
    call.update(status: 'active')

    # Broadcast to caller that call was accepted
    Turbo::StreamsChannel.broadcast_replace_to(
      "user_#{call.caller_id}",
      target: "outgoing_call",
      partial: "calls/active_call",
      locals: { call: call }
    )

    render turbo_stream: turbo_stream.replace(
      "incoming_calls",
      partial: "calls/active_call",
      locals: { call: call }
    )
  end

  def end
    call = Call.find_by(uuid: params[:id])
    call.update(status: 'ended')

    # Broadcast to the other party that call ended
    other_user_id = current_user.id == call.caller_id ? call.recipient_id : call.caller_id

    Turbo::StreamsChannel.broadcast_replace_to(
      "user_#{other_user_id}",
      target: "active_call",
      partial: "calls/call_ended",
      locals: { call: call }
    )

    render turbo_stream: turbo_stream.replace(
      "active_call",
      partial: "calls/call_ended",
      locals: { call: call }
    )
  end
end