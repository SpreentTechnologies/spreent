class AvatarsController < ApplicationController
  before_action :authenticate_user!

  def update
    respond_to do |format|
      if current_user.avatar.attach(params[:avatar][:image])
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace('avatar_section',
                                 partial: 'settings/avatar_section',
                                 locals: { user: current_user }
            ),
            turbo_stream.prepend('flash_messages',
                                 partial: 'shared/flash',
                                 locals: { flash: { success: 'Avatar updated successfully' } }
            )
          ]
        }
        format.html {
          redirect_to settings_path, notice: 'Avatar updated successfully'
        }
      else
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace('avatar_section',
                                 partial: 'settings/avatar_section',
                                 locals: { user: current_user }
            ),
            turbo_stream.prepend('flash_messages',
                                 partial: 'shared/flash',
                                 locals: { flash: { error: 'Failed to update avatar' } }
            )
          ]
        }
        format.html { render 'settings/show' }
      end
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
end