class ChatsController < ApplicationController
  def create
    application = Application.find_by(token: params[:application_token])

    if application.nil?
      return render json: { error: 'Application not found' }, status: :not_found
    end

    # Generate the next chat number for this app
    next_number = application.chats.count + 1

    chat = application.chats.build(number: next_number)

    if chat.save
      render json: { number: chat.number }, status: :created
    else
      render json: { errors: chat.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    application = Application.find_by(token: params[:application_token])
    return render json: { error: 'Application not found' }, status: :not_found if application.nil?

    chat = application.chats.find_by(number: params[:number])
    return render json: { error: 'Chat not found' }, status: :not_found if chat.nil?

    render json: { number: chat.number, messages_count: chat.messages.count }
  end

  def index
    application = Application.find_by(token: params[:application_token])
    return render json: { error: 'Application not found' }, status: :not_found if application.nil?

    chats = application.chats.order(:number)
    # render json: chats.select(:number, :messages_count)
    render json: chats.as_json(only: [:number, :messages_count])
  end
end
 