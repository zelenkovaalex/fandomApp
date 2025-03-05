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
end