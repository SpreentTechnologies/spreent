class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @likes = Post.find(params[:post_id]).likes.where(user_id: current_user.id).count

    puts @likes
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)
    @like.destroy if @like

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("like_button_#{@post.id}",
                                                                      partial: "posts/like_button", locals: { post: @post }) }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end