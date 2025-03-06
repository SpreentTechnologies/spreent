class ChallengesController < ApplicationController
  def index
    @community = Community.find(params[:community_id])
    @challenges = @community.challenges.order(created_at: :desc)
  end
end