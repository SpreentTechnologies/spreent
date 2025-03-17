class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace("follow_button_#{@user.id}",
                               partial: 'users/follow_button',
                               locals: { user: @user }),
          turbo_stream.replace("follower_count_#{@user.id}",
                               partial: 'users/follower_count',
                               locals: { user: @user })
        ]
      }
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def destroy
    current_user.unfollow(@user)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("follow_button_#{@user.id}",
                                                                      partial: 'users/follow_button',
                                                                      locals: { user: @user })
      }
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end