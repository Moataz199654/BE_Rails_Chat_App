class ApplicationsController < ApplicationController
  def create
    token = SecureRandom.hex(10)

    application = Application.new(application_params.merge(token: token))

    if application.save
      render json: { token: application.token, name: application.name }, status: :created
    else
      render json: { errors: application.errors.full_messages }, status: :unprocessable_entity
    end
  end

    
  def show
    application = Application.find_by(token: params[:token])

    if application
      render json: { token: application.token, name: application.name }
    else
      render json: { error: "Application not found" }, status: :not_found
    end
  end

  private

  def application_params
    params.require(:application).permit(:name)
  end
end
