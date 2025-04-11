class FeedController < ApplicationController
  before_action :authenticate_user!
  before_action :require_user_confirmation!
  layout "app_with_nav"

  def index
    @page = params[:page] || 1
    @posts = Post.order(created_at: :desc).paginate(page: @page, per_page: 10)
    last_page = @posts.total_pages <= @posts.current_page
    @new_post = Post.new

    respond_to do |format|
      format.html
      format.json { render json: { posts: render_to_string(partial: "posts", formats: [:html]), last_page: last_page}}
    end
  end

  private

  def require_user_confirmation!
    unless current_user.confirmed?
      redirect_to root_path, alert: "You need to confirm your email before accessing this page."
    end
  end
end
