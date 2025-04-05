class ConversationsController < ApplicationController
  layout 'app_with_nav'
  before_action :authenticate_user!
  def index
    @conversations = current_user.conversations.includes(:sender, :recipient, messages: :user)
                                 .order("messages.created_at DESC")

    # Add search functionality
    if params[:query].present?
      search_term = "%#{params[:query]}%"

      # Find users that match the search term
      user_ids = User.where("name LIKE ? OR email LIKE ?", search_term, search_term)
                     .where.not(id: current_user.id)
                     .pluck(:id)

      # Filter conversations with those users
      @conversations = @conversations.where(
        "sender_id IN (?) OR recipient_id IN (?)",
        user_ids, user_ids
      )
    end

    # Get users for new conversation creation
    @users = User.where.not(id: current_user.id)

    # For the new conversation form
    @new_conversation = Conversation.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @conversation = Conversation.includes(messages: :user)
                                .find(params[:id])
    @message = Message.new

    # Mark messages as read
    @conversation.messages.where.not(user_id: current_user.id).update_all(read: true)
  end

  def create
    if Conversation.between(params[:conversation][:sender_id], params[:conversation][:recipient_id]).present?
      @conversation = Conversation.between(params[:conversation][:sender_id], params[:conversation][:recipient_id]).first
    else
      @conversation = Conversation.create!(
        sender_id: params[:conversation][:sender_id],
        recipient_id: params[:conversation][:recipient_id]
      )
    end

    redirect_to conversation_path(@conversation)
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end
end
