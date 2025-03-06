class CommentsController < ApplicationController
  before_action :set_post

  def index
    @comments = @post.comments.order(created_at: :desc)
    @comment = Comment.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.turbo_stream
      else
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