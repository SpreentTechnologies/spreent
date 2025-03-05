class AdminController < ApplicationController
  layout 'app_with_nav'
  before_action :require_admin

  def index
    @invitation_codes = InvitationCode.all
    @new_invitation_code = InvitationCode.new
  end

  private

  def require_admin
    redirect_to feed_path, alert: 'Access denied.' unless current_user.user_type == 'admin'
  end
end