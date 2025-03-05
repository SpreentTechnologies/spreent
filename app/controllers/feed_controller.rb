class FeedController < ApplicationController
  before_action :authenticate_user!
  layout 'app_with_nav'

  def index
    @posts = Post.order(created_at: :desc).page(params[:page])
    @new_post = Post.new
  end
end
