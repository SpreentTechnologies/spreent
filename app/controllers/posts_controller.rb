class PostsController < ApplicationController

  def new
    @post = current_user.posts.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path, notice: 'Post was successfully created.' }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("posts_list", partial: "posts/post", locals: { post: @post }),
            turbo_stream.replace("new_post_form", partial: "posts/form", locals: { post: current_user.posts.new })
          ]
        end
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(
          "new_post_form",
          partial: "posts/form",
          locals: { post: @post }
        ) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end


  end

  private

  def post_params
    params.require(:post).permit(:content, :challenge_id, media: [])
  end
end
