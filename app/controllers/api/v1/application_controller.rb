class Api::V1::ApplicationController < ActionController::API
  def decrypt_payload
    jwt = request.headers["Authorization"]

    if jwt.present?
      begin
        payload = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })[0]
        return payload
      rescue JWT::DecodeError
        return nil 
      end
    else
      return nil
    end
  end

  private

  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end

  def record_invalid(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
  
end