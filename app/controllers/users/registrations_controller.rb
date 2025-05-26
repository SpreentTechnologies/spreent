class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_invitation_code, only: [:new, :create]
  layout "full"

  def create
    build_resource(sign_up_params)
    resource.invitation_code = session[:invitation_code] # Assign code

    if resource.save
      InvitationCode.find_by(code: session[:invitation_code])&.increment!(:used_count)
      session[:invitation_code] = nil # Clear after use
      sign_up(resource_name, resource)

      sign_in(resource_name, resource)

      if resource.active_for_authentication?

        # Send a PostHog update
        PostHog.capture(
          distinct_id: resource.id,
          event: 'user_registered',
          properties: {
            email: resource.email,
            sign_up_date: Time.now,
          }
        )

        set_flash_message! :notice, :signed_up
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end

    else
      respond_with resource
    end
  end

  private

  def after_sign_up_path_for(resource)
    feed_path
  end

  def check_invitation_code
    redirect_to invite_verify_path, alert: I18n.t('home.enter_invitation_code_first') unless session[:invitation_code].present?
  end
end
