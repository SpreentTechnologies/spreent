class ProfileController < ApplicationController
  layout 'app_with_nav'
  def index
    # My own profile
  end

  def show

  end

  def update
    # Update the profile of the current_user
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "Profile updated successfully"
      redirect_to settings_path
    else
      flash[:error] = "Failed to update profile"
      render :index
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :bio, :avatar)
  end
end