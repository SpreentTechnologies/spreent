class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def new
    @report = @post.reports.new

    # Automatically open the modal when this action is rendered
    respond_to do |format|
      format.html # This renders a regular view for turbo_frame
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("body",
                                                 partial: "reports/open_modal",
                                                 locals: { post: @post }
        )
      end
    end
  end

  def create
    @report = @post.reports.new(report_params)
    @report.user = current_user

    respond_to do |format|
      if @report.save
        format.html {
          # Render a success page that includes JS to show the success message
          render "create", locals: { post: @post }
        }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def report_params
    params.require(:report).permit(:reason, :details)
  end
end