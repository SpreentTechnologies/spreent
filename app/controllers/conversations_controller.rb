class ConversationsController < ApplicationController
  layout 'app_with_nav'
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]

  def index
    @conversations = current_user.conversations.includes(:users, :messages)
                                 .order("messages.created_at DESC")
  end

  def show
    @messages = @conversation.messages.includes(:user).order(created_at: :asc)
    @message = Message.new
    @conversation.mark_as_read_for(current_user)

    # For starting a new conversation with a specific user
    @users = User.where.not(id: current_user.id)
  end

  def create
    other_user = User.find(params[:user_id])
    @conversation = current_user.start_conversation_with(other_user)

    redirect_to conversation_path(@conversation)
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end
end