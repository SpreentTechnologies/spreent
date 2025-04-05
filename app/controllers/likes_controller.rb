class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = @post.likes.new(user: current_user)

    respond_to do |format|
      if @like.save
        if @post.user_id != current_user.id
          if [10, 50, 100, 500, 1000].include?(@post.likes.count)
            Notification.create_notification(
              recipient: @post.user,
              actor: nil,
              notifiable: current_user,
              category: :achievement,
              message: "Your post received #{@post.likes.count} likes for the first time"
            )
          else
            Notification.create_notification(
            recipient: @post.user,
            actor: @post.user,
            notifiable: current_user,
            category: :social,
            message: "#{current_user.name} liked your post"
            )
          end
        end
        format.turbo_stream { render turbo_stream: turbo_stream.replace("like_button_#{@post.id}",
                                                                        partial: "posts/like_button", locals: { post: @post }) }
      else
        format.html { redirect_to @post, alert: "Couldn't like the post" }
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