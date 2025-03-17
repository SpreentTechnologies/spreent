class SearchController < ApplicationController
  def index
    @query = params[:query]

    if @query.present?
      @community_results = search_communities(@query)
      @user_results = search_users(@query)
    else
      @community_results = []
      @user_results = []
    end

      respond_to do |format|
        format.html
      end
    end

  private

  def search_communities(query)
    # Implement your search logic here
    Community.where("name LIKE ?", "%#{query}%")
  end

  def search_users(query)
    User.where("email LIKE ? OR name LIKE ?", "%#{query}%", "%#{query}%")
  end
end