class MessagesController < ApplicationController
  def create
    application = Application.find_by(token: params[:application_token])
    return render json: { error: 'Application not found' }, status: :not_found if application.nil?

    chat = application.chats.find_by(number: params[:chat_number])
    return render json: { error: 'Chat not found' }, status: :not_found if chat.nil?

    next_number = chat.messages.count + 1

    message = chat.messages.build(number: next_number, content: message_params[:content])
    if message.save
      render json: { number: message.number, content: message.content }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
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
