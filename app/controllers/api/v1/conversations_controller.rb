class Api::V1::ConversationsController < Api::V1::BaseController
  before_action :authorize
  before_action :find_recipient, only: [ :create ]
  before_action :set_conversation, only: [ :destroy ]
  before_action :validate_owner, only: [:destroy]
  

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

  # DELETE /conversations/:conversation_id
  def destroy
    if @conversation.destroy
      render json: { message: "Conversation destroyed." }
    else 
      render json: { errors: "Some error occured. Couldn't delete conversation." }, status: 500
    end
  end

private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def conversation_params
    params.require(:conversation).permit(:recipient_id)
  end

  def find_recipient
    @recipient = User.find_by_hashid(conversation_params[:recipient_id])
    render json: { errors: "Couldn't find user with id=#{params[:recipient_id]}" }, status: 404 if @recipient.nil?
  end

  def validate_owner
    render json: { errors: "You are not the owner of this conversation" }, status: :unauthorized if not @current_user.id == @conversation.user_id
  end
end
