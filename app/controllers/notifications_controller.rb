class NotificationsController < ApplicationController
  before_action :authenticate_user!

  layout 'app_with_nav'
  def index
    @notifications = current_user.notifications.order(created_at: :desc)

    @recent_notifications = @notifications.recent.limit(5)
    @today_notifications = @notifications.today
    @yesterday_notifications = @notifications.yesterday

    @notifications.each do |notification|
      notification.mark_as_read!
    end

    respond_to do |format|
      format.html
      format.json { render json: @notifications }
    end
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!

    redirect_back(fallback_location: notifications_path)
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.zone.now)

    redirect_back(fallback_location: notifications_path)
  end

  def communities
    @recent_notifications = current_user.notifications.order(created_at: :desc)
    @today_notifications = current_user.notifications.today
    @yesterday_notifications = current_user.notifications.yesterday
  end

  def challenges

  end
end
