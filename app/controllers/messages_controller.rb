class MessagesController < ApplicationController
  def create
    application = Application.find_by(token: params[:application_token])

    if application.nil?
      return render json: { error: 'Application not found' }, status: :not_found
    end

    retries ||= 0
    begin
      chat = application.chats.find_by(number: params[:chat_number])
      return render json: { error: "Chat not found" }, status: :not_found if chat.nil?

      next_number = (chat.messages.maximum(:number) || 0) + 1

      message = chat.messages.build(number: next_number, content: message_params[:content])
      if message.save
        render json: { number: message.number, content: message.content }, status: :created
      else
        render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique
      retries += 1
      retry if retries < 10
        render json: { error: "Could not create message due to race condition" }, status: :conflict
    end
  end

  def index
    application = Application.find_by(token: params[:application_token])
    return render json: { error: 'Application not found' }, status: :not_found if application.nil?

    chat = application.chats.find_by(number: params[:chat_number])
    return render json: { error: 'Chat not found' }, status: :not_found if chat.nil?

    messages = chat.messages.order(:number)
    render json: messages.select(:number, :content)
  end

  
  def show
    application = Application.find_by(token: params[:application_token])
    return render json: { error: 'Application not found' }, status: :not_found if application.nil?

    chat = application.chats.find_by(number: params[:chat_number])
    return render json: { error: 'Chat not found' }, status: :not_found if chat.nil?

    message = chat.messages.find_by(number: params[:number])
    return render json: { error: 'Message not found' }, status: :not_found if message.nil?
    render json: { number: message.number, content: message.content }
  end 


  private

  def message_params
    params.require(:message).permit(:content)
  end
end
