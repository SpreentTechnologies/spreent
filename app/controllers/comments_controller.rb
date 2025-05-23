class CommentsController < ApplicationController
  before_action :set_post

  def index
    @comments = @post.comments.order(created_at: :asc)
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

      if @comment.save
        if current_user.id != @comment.user_id
          Notification.create_notification(
            recipient: current_user,
            actor: current_user,
            notifiable: @comment,
            category: :social,
            message: "#{@comment.user.name} commented: #{@comment.content.truncate(30)}"
          )
        end

        respond_to do |format|
          @comments = @post.comments.order(created_at: :asc)
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("comments", partial: "comments/comments_list", locals: { comments: @comments }),
              turbo_stream.replace("comment_form", partial: "comments/form", locals: { post: @post, comment: Comment.new }),
              turbo_stream.replace("post_#{@post.id}_comment_count", partial: "posts/comment_count", locals: { post: @post, comments: @comments } )
            ]
          end
        end
      else
        respond_to do |format|
          format.turbo_stream {
            render turbo_stream: turbo_stream.replace(
              "comment_form",
              partial: "comments/form",
              locals: { post: @post, comment: @comment }
            )
          }
        end
      end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end