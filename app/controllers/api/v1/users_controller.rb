class Api::UsersController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:login]
  before_action :set_profile, only: [:profile, :update_profile]

  def login
    user = User.find_for_database_authentication(email: params[:email])

    if user&.valid_password?(params[:password])
      render json: {
        message: 'OK',
        token: generate_token(user),
        user: {
          id: user.id,
          email: user.email
        }
      }
    else
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end
  end

  def profile
    render json: {
      user: {
        id: current_user.id,
        email: current_user.email,
        name: @profile&.name,
        bio: @profile&.bio
      },
      profile: @profile 
    }
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_profile
    if @profile.update(profile_params)
      render json: {
        message: 'Profile updated successfully',
        user: {
          id: current_user.id,
          email: current_user.email,
          name: @profile.name,
          bio: @profile.bio
        },
        profile: @profile
      }
    else
      render json: { message: 'Failed to update profile', errors: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def generate_token(user)
    payload = {
      user_id: user.id,
      email: user.email,
      jti: user.jti,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
  end

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

  def set_profile
    @profile = current_user.profile || current_user.create_profile 
  end

  def profile_params
    params.require(:profile).permit(:name, :bio, :avatar)
  end

  def user_params
    params.require(:user).permit(:email, :password, :avatar)
  end
end