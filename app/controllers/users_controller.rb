class UsersController < ApplicationController
  layout 'full_with_nav'
  def show
    # Include the user's posts
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end
end