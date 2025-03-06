# app/controllers/call_interface_controller.rb
class CallInterfaceController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id)
    @active_call = Call.where("(caller_id = ? OR recipient_id = ?) AND status IN (?)",
                              current_user.id, current_user.id, ['pending', 'active'])
                       .order(created_at: :desc).first
  end
end