class InvitationCodesController < ApplicationController
  before_action :authenticate_user!, only: ['create']
  before_action :require_admin, only: ['create', 'destroy']

  def create
    @new_invitation_code = InvitationCode.new(invitation_code_params)

    respond_to do |format|
      if @new_invitation_code.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend('invitation_codes', partial: 'invitation_codes/invitation_code', locals: { invitation_code: @new_invitation_code }),
            turbo_stream.replace('new_invitation_code_form', partial: 'admin/invitation_code_form')
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('new_invitation_code_form', partial: 'admin/invitation_code_form')
        end
      end
    end
  end

  def destroy
    @invitation_code = InvitationCode.find(params[:id])
    @invitation_code.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@invitation_code)
      end
    end
  end

  def verify
    session[:invitation_code] = nil
  end

  def check
    code = InvitationCode.find_by(code: params[:invitation_code])

    if code.present? && (code.expires_at.nil? || code.expires_at.future?) && (code.max_uses.nil? || code.used_count < code.max_uses)
      session[:invitation_code] = code.code
      redirect_to new_user_registration_path
    else
      flash[:alert] = "Invalid invitation code."
      render :verify
    end
  end

  private

  def require_admin
    redirect_to feed_path, alert: 'Access denied.' unless current_user.user_type == 'admin'
  end

  def invitation_code_params
    params.require(:invitation_code).permit(:code)
  end
end
