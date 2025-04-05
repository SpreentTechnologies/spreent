class PostsController < ApplicationController
  def create
    @new_post = current_user.posts.build(post_params)

    respond_to do |format|
      if @new_post.save
        $posthog.capture(
          distinct_id: current_user.email,
          event: "post_created",
          properties: {
            post_id: @new_post.id
          }
        )
        # @project_api_key = 'phc_MTEDYMT3VxmLUK30Cvno1b3So27daWvfJBrOWt31hCb'
        # cookie_key = "ph_#{@project_api_key}_posthog"

        # if cookies[cookie_key].present?
        #   @ph_cookie = JSON.parse(cookies[cookie_key])
        # else
        #   @ph_cookie = nil  # Or set a default value
        # end

        # $posthog.alias({
        #   distinct_id: current_user.email,
        #   alias: @ph_cookie['distinct_id']
        # });
        format.html {
          if @new_post.community_id
            redirect_to community_path(@new_post.community)

          elsif @new_post.challenge_id
            redirect_to challenge_path(@new_post.challenge)
          else
            @posts = Post.all
            redirect_to feed_path(@posts)
          end
        }
      end
      end
    end

  private

  def post_params
    params.require(:post).permit(:content, :challenge_id, media: [])
  end
end
