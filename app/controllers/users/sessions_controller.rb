class Users::SessionsController < Devise::SessionsController

  def create
    if user && user.valid_password?(params[:user][:password])
      # success logic
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def after_sign_in_path_for(resource)
    feed_path  # Custom path after login
  end

  def after_sign_out_path_for(resource_or_scope)
    home_path  # Custom logout redirect
  end
end