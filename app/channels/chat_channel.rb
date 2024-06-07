class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  
  def send_message(data)
    user = User.find(data["user_id"])
    message = user.messages.create(content: data["message"])
    ActionCable.server.broadcast "chat_channel", message: render_message(message)
  end

  private

  def render_message(message)
    ApplicationController.render(
      partial: 'messages/message',
      locals: { message: message }
    )
  end
end
