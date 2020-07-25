class MessagesChannel < ApplicationCable::Channel
  def subscribed
    # Get the conversation by the conversation id in the parameters
  	@conversion = Conversion.find(params[:conversation_id])
    # Reject unauthorized listeners
  	reject unless @conversation.allowed?(current_user)
    # Stream if authorized from the conversation channel
    stream_for @conversation
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
