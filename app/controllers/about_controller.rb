class AboutController < ApplicationController
  layout "full"
  before_action :redirect_if_logged_in

  def index

  end

  private

  def redirect_if_logged_in
    if user_signed_in?
      redirect_to feed_path
    end
  end
end
