class NotificationsController < ApplicationController
  before_action :authenticate_user!

  layout 'app_with_nav'
  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end
end
