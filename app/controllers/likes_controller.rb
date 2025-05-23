class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @likes = Post.find(params[:post_id]).likes.where(user_id: current_user.id).count

    if @likes == 0
      @likes = Post.find(params[:post_id]).likes.create(user_id: current_user.id)

      # Check if the post is liked by atleast 5 users
      # if @post.likes.count == 1
      #   Notification.create(
      #     recipient: @post.user,
      #     recipient_type: "User",
      #     actor: current_user,
      #     actor_type: "User",
      #     notifiable: @post,
      #     message: "Your post has been liked by atleast a user!",
      #   )
      # end
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("like_button_#{@post.id}",
                                                                        partial: "posts/like_button", locals: { post: @post }) }
      end
    end
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