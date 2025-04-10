class Api::V1::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication, only: [:create]
  skip_before_action :verify_authenticity_token
  
  def create
    @user = User.new(user_params)
    if @user.save
      render json: {
        message: 'Sign Up Successful',
        user: {
          id: @user.id,
          email: @user.email,
          jwt: encrypt_payload
        }
      }, status: :created
    else
      render json: {
        message: 'Sign Up Failed',
        errors: @user.errors.full_messages # Выводим ошибки валидации
      }, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def encrypt_payload
      payload = @user.as_json(only: [:email, :jti])
      token = JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
    end

end