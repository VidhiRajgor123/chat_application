class MessagesController < ApplicationController
    before_action :authenticate_user!

    def index
        @messages = Message.where(user_id: current_user.id)
    end

    def create
        @message = current_user.messages.create(content: params[:content])
        if @message.save
          ActionCable.server.broadcast "chat_channel", message: render_message(@message)
          head :ok
        else
          render json: @message.errors, status: :unprocessable_entity
        end
    end
    
    private

    def render_message(message)
        ApplicationController.render(
            partial: 'messages/message',
            locals: { message: message }
        )
    end
end
