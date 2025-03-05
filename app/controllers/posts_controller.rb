class PostsController < ApplicationController
  def create
    @new_post = current_user.posts.build(post_params)

    respond_to do |format|
      if @new_post.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend('posts', partial: 'posts/post', locals: { post: @new_post }),
            turbo_stream.replace('new_post_form', partial: 'posts/form', locals: { post: Post.new })
          ]
        end
        format.html { redirect_to posts_path, notice: 'Post created successfully.' }
    else
    # If validation fails, re-render the form with errors
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        'new_post_form',
        partial: 'posts/form',
        locals: { post: @new_post }
      )
    end
    format.html { render :new }
    end
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, media: [])
  end
end
