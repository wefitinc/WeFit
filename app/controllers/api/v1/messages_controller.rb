class Api::V1::MessagesController < Api::V1::BaseController
  # Always authorize the user
  before_action :authorize
  # Always make sure we're in a conversation
  before_action :set_conversation
  # Always check that this user is in the conversation
  before_action :check_in_conversation

  # After we get messages, mark them as read 
  after_action :read_all, only: [ :index, :filter ]

  # GET /conversations/:conversation_id/messages
  def index
    @messages = @conversation.messages.order('id DESC').page(@page_param)
    render json: @messages 
  end
  
  # POST /conversations/:conversation_id/messages/filter
  def filter
    @messages = @conversation.messages
    @messages = @messages.where('id > ?', filter_params[:last_message]).order('id DESC').page(@page_param) if filter_params[:last_message]
    render json: @messages
  end

  # POST /conversations/:conversation_id/messages
  def create
    # Create the new message
    @message = @conversation.messages.new(message_params)
    byebug
    @message.user_id = @current_user.id
    # Save to DB
    if @message.save then
      # Broadcast the message to the conversation channel
      MessagesChannel.broadcast_to(@conversation, @message)
      # Render the message
      render json: @message
    else
      render json: { errors: @message.errors }
    end
  end

  # POST /conversations/:conversation_id/messages/destroy_messages
  def destroy_messages
    @messages = @conversation.messages.where(id: params[:message_ids], user_id: @current_user.id)
    if @messages.destroy_all
      render json: { message: "Message(s) deleted" }
    else
      render json: { errors: "Some error occured. Couldn't delete messages." }, status: 500
    end
  end

private
  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
  def check_in_conversation
    @in_conversation = (@conversation.sender == @current_user) || (@conversation.recipient == @current_user) 
    unless @in_conversation
      render json: { error: "You are not a member of this conversation" }, status: :unauthorized
    end
  end

  def filter_params
    params.permit(:last_message)
  end
  def message_params
    params.require(:message).permit(:body, :messageable_type, :messageable_id, user_location: {}, media_urls: [])
  end

  # Update all messages that aren't written by this user to be read
  def read_all
    @messages
      .where.not(user_id: @current_user.id)
      .update_all(read:true)
  end
end
