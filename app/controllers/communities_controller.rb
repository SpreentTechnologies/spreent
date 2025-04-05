class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :join, :leave, :update]
  before_action :ensure_owner, only: [:update]
  before_action :authenticate_user!, only: [:join, :leave]

  layout "app_with_nav"

  def index
    @sport = Sport.find(params[:sport_id])
    @communities = @sport.communities
  end

  def show
    @is_member = current_user && @community.members.include?(current_user)
    @posts = @community.posts.includes(:user).page(params[:page]).order(created_at: :desc)

    @current_challenges = @community.challenges.current.order(start_date: :asc)
    @past_challenges = @community.challenges.past.order(end_date: :desc).limit(10)
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(community_params)
    @community.admin = current_user

    if @community.save
      redirect_to community_path(@community)
    else
      flash[:alert] = @community.errors.full_messages
      render :new
    end
  end

  def join
      membership = Membership.new(user: current_user, community: @community)
      if membership.save
        render json: {
          success: true,
          message: "Successfully joined the community",
        }
      else
        render json: {
          success: false,
          message: membership.errors.full_messages.to_sentence,
        }
      end
  end

  def leave
    membership = CommunityMembership.find_by(user: current_user, community: @community)

    respond_to do |format|
      if membership&.destroy
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("membership_status",
                                 partial: "communities/membership_status",
                                 locals: { community: @community, is_member: false }),
            turbo_stream.replace("member_count",
                                 partial: "communities/member_count",
                                 locals: { community: @community })
          ]
        end
        format.html { redirect_to @community, notice: "You've left this community." }
      else
        format.html { redirect_to @community, alert: "Could not leave this community." }
      end
    end
  end

  def update

    # Ensure the user is authorized
    unless current_user&.owns?(@community)
      return redirect_to @community, alert: "You don't have permission to perform this action."
    end

    if params[:community] && params[:community][:banner].present?
        @community.banner.attach(params[:community][:banner])
    end

    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to @community, notice: "Community was successfully updated." }
        format.json { render :show, status: :ok, location: @community }
        format.turbo_stream { flash.now[:notice] = "Banner updated successfully!" }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @community.errors, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:alert] = "Failed to update banner." }
      end
    end
  end

  private

  def set_community
    @community = Community.find(params[:id])
  end

  def ensure_owner
    unless current_user&.owns?(@community)
      redirect_to @community, alert: "You don't have permission to perform this action."
    end
  end

  def community_params
    params.require(:community).permit(:name, :description, :sport_id, :level, :privacy, :location, :banner)
  end
end
