class PostsController < ApplicationController
  def create
    @new_post = current_user.posts.build(post_params)

    respond_to do |format|
      if @new_post.save
        $posthog.capture(
          distinct_id: current_user.id,
          event: 'post_created',
          properties: {
            post_id: @new_post.id,
          }
        )
        @project_api_key = 'phc_MTEDYMT3VxmLUK30Cvno1b3So27daWvfJBrOWt31hCb'
        @ph_cookie = JSON.parse(cookies["ph_#{@project_api_key}_posthog"])

        $posthog.alias({
          distinct_id: current_user.id,
          alias: @ph_cookie['distinct_id']
        });

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
