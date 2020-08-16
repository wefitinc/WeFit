class Api::V1::ConversationsController < Api::V1::BaseController
  before_action :authorize
  before_action :find_recipient, only: [ :create ]

  # GET /conversations
  def index
    @conversations = @current_user.conversations
    render json: @conversations
  end

  # POST /conversations
  def create
    if Conversation.between(@current_user.id, @recipient.id).exists?
      @conversation = Conversation.between(@current_user.id, @recipient.id).first
    else 
      @conversation = Conversation.create(sender_id: @current_user.id, recipient_id: @recipient.id)
    end
    render json: @conversation
  end

private
  def conversation_params
    params.require(:conversation).permit(:recipient_id)
  end

  def find_recipient
    @recipient = User.find_by_hashid(conversation_params[:recipient_id])
    render json: { errors: "Couldn't find user with id=#{params[:recipient_id]}" }, status: 404 if @recipient.nil?
  end
end
