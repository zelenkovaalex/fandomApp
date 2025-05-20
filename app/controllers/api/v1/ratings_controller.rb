class Api::V1::RatingsController < ApplicationController
    before_action :authenticate_user!

    def create
    trail = Trail.find(params[:trail_id])
    rating = current_user.ratings.find_or_initialize_by(trail: trail)
    rating.value = params[:value]

    if rating.save
        render json: { message: 'Rating saved successfully', rating: rating }, status: :created
    else
        render json: { errors: rating.errors.full_messages }, status: :unprocessable_entity
    end
    end

    private

    def authenticate_user!
    auth_header = request.headers['Authorization']
    if auth_header
      token = auth_header.split(' ').last
      begin
        payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })[0]
        @current_user = User.find_by(jti: payload['jti']) 

        unless @current_user
          render json: { message: 'Invalid token' }, status: :unauthorized
        end
      rescue JWT::DecodeError
        render json: { message: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { message: 'Missing token' }, status: :unauthorized
    end
  end
end
