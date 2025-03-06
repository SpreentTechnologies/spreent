class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :join, :leave]
  before_action :authenticate_user!, only: [:join, :leave]
  layout 'app_with_nav'

  def index
    @sport = Sport.find(params[:sport_id])
    @communities = @sport.communities
  end

  def show
    @is_member = current_user && @community.members.include?(current_user)
  end

  def join
    unless @community.members.include?(current_user)
      membership = CommunityMembership.new(user: current_user, community: @community)

      respond_to do |format|
        if membership.save
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("membership_status",
                                   partial: "communities/membership_status",
                                   locals: { community: @community, is_member: true }),
              turbo_stream.replace("member_count",
                                   partial: "communities/member_count",
                                   locals: { community: @community })
            ]
          end
          format.html { redirect_to @community, notice: "You've joined this community!" }
        else
          format.html { redirect_to @community, alert: "Could not join this community." }
        end
      end
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

  private

  def set_community
    @community = Community.find(params[:id])
  end
end