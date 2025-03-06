class SportsController < ApplicationController
  def create
    @category = Category.find(params[:category_id])
    @sport = @category.sports.build(sport_params)

    respond_to do |format|
      if @sport.save
        format.turbo_stream
        format.html { redirect_to categories_path, notice: "Sport was successfully added." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def sport_params
    params.require(:sport).permit(:name, :description, :image)
  end
end