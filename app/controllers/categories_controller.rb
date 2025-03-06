class CategoriesController < ApplicationController
  layout 'app_with_nav'
  def index
    @categories = Category.includes(:sports).all
  end
end