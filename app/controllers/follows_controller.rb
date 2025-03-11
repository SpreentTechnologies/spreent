class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]

  def create
    current_user.follow(@user)
    respond_to_follow_action
  end

  def destroy
    current_user.unfollow(@user)
    respond_to_follow_action
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def respond_to_follow_action
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("follow_form_#{@user.id}",
                               partial: 'users/follow_form',
                               locals: { user: @user }),
          turbo_stream.update("followers_count_#{@user.id}",
                              @user.followers.count.to_s),
          turbo_stream.update("following_count_#{current_user.id}",
                              current_user.following.count.to_s)
        ]
      end
      format.html { redirect_back(fallback_location: root_path) }
    end
  end
end