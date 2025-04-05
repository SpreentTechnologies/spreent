class SettingsController < ApplicationController
  layout 'app_with_nav'
  before_action :authenticate_user!

  def show
    @user = current_user
    # For displaying the avatar upload form
    @avatar = Avatar.new
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update(user_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace('profile_settings',
                                 partial: 'settings/profile_settings',
                                 locals: { user: @user }
            ),
            turbo_stream.prepend('flash_messages',
                                 partial: 'shared/flash',
                                 locals: { flash: { success: 'Profile updated successfully' } }
            )
          ]
        }
        format.html {
          redirect_to settings_path, notice: 'Profile updated successfully'
        }
      else
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace('profile_settings',
                                 partial: 'settings/profile_settings',
                                 locals: { user: @user }
            ),
            turbo_stream.prepend('flash_messages',
                                 partial: 'shared/flash',
                                 locals: { flash: { error: 'Failed to update profile' } }
            )
          ]
        }
        format.html { render :show }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :bio, :public_email,
                                 :theme_preference, :notification_preferences, :location)
  end
end