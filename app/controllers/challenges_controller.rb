class ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community, only: [:create]
  before_action :ensure_member, only: [:create]
  before_action :require_user_confirmation!

  before_action :set_challenge, only: [:show, :join]
  layout 'app_with_nav'
  def index
    @community = Community.find(params[:community_id])
    @challenges = @community.challenges.order(created_at: :desc)
  end

  def create
    @challenge = @community.challenges.new(challenge_params)
    @challenge.user = current_user

    if @challenge.save
      render json: {
        success: true,
        message: 'Challenge created successfully',
        challenge: @challenge
      }
    else
      render json: {
        success: false,
        message: 'Failed to create challenge',
        errors: @challenge.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def show
    @user_progress = 0
    @posts = @challenge.posts.order(created_at: :desc)
    @new_post = Post.new

    if current_user&.participating_in?(@challenge)
      # Calculate progress based on days elapsed
      total_days = (@challenge.end_date - @challenge.start_date).to_i
      days_passed = (Date.today - @challenge.start_date).to_i

      # Ensure we don't go over 100% or below 0%
      if days_passed < 0
        @user_progress = 0
      elsif days_passed > total_days
        @user_progress = 100
      else
        @user_progress = ((days_passed.to_f / total_days) * 100).round
      end
    end
  end

  def join
    # Check if user is already participating
    if current_user.participating_in?(@challenge)
      render json: {
        success: true,
        message: 'You are already participating in this challenge',
        participant_count: @challenge.participants.count
      }
      return
    end

    # Create participation
    participation = Participation.new(user: current_user, challenge: @challenge)

    if participation.save
      render json: {
        success: true,
        message: 'Successfully joined the challenge',
        participant_count: @challenge.participants.count
      }
    else
      render json: {
        success: false,
        message: 'Failed to join the challenge',
        errors: participation.errors.full_messages
      }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error("Error in join action: #{e.message}")
    render json: {
      success: false,
      message: 'An error occurred while processing your request'
    }, status: :internal_server_error
  end

  def invite
    @challenge = Challenge.find(params[:id])

    # Check if current user can invite others
    unless current_user.member_of?(@challenge.community)
      render json: {
        success: false,
        message: "You must be a member of this community to invite others"
      }, status: :forbidden
      nil
    end

    user_ids = params[:user_ids] || []

    # Track successful invites
    successful_invites = 0
    failed_invites = 0

    user_ids.each do |user_id|
      begin
        user = User.find(user_id)

        # Skip if the user is already participating
        next if user.participating_in?(@challenge)

        # Create the invitation
        invitation = ChallengeInvitation.new(
          challenge: @challenge,
          sender: current_user,
          recipient: user
        )

        if invitation.save
          # Increase counter for successful invites
          successful_invites += 1

          # Send notification to user (in a real app)
          # NotificationService.notify(user, "You've been invited to join #{@challenge.name}")
        else
          # Increase counter for failed invites
          failed_invites += 1
        end
      rescue ActiveRecord::RecordNotFound
        failed_invites += 1
      end
    end

    render json: {
      success: true,
      message: "Successfully sent #{successful_invites} invitations",
      successful_invites: successful_invites,
      failed_invites: failed_invites
    }
  end

  private

  def challenge_params
    params.require(:challenge).permit(:name, :description, :rules, :start_date, :end_date)
  end

  def set_community
    @community = Community.find(params[:challenge][:community_id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: 'Community not found' }, status: :not_found
  end

  def ensure_member
      unless current_user.member_of?(@community)
        render json: {
          success: false,
          message: 'You must be a member of this community to create challenges'
        }, status: :forbidden
      end
  end

  def set_challenge
    @challenge = Challenge.find(params[:id])
  end

  def require_user_confirmation!
    unless current_user.confirmed?
      redirect_to root_path, alert: "You need to confirm your email before accessing this page."
    end
  end
end