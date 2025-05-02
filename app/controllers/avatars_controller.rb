class AvatarsController < ApplicationController
  before_action :authenticate_user!

  def update
    user = current_user

    if user.update(user_params)
      # Return JSON with avatar URL for Stimulus controller
      render json: {
        avatar_url: Rails.application.routes.url_helpers.rails_representation_url(
          user.avatar.variant(resize_to_fill: [200, 200]),
          only_path: true
        ),
        success: true
      }
    else
      render json: {
        errors: user.errors.full_messages,
        success: false
      }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.avatar.purge

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.replace('avatar_section',
                               partial: 'settings/avatar_section',
                               locals: { user: current_user }
          ),
          turbo_stream.prepend('flash_messages',
                               partial: 'shared/flash',
                               locals: { flash: { success: 'Avatar removed' } }
          )
        ]
      }
      format.html {
        redirect_to settings_path, notice: 'Avatar removed'
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end
end