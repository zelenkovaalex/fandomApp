class Api::V1::SessionsController < Devise::SessionsController
  # skip_before_action :verify_authenticity_token, only: [ :create, :destroy ]
  # skip_before_action :verify_signed_out_user, only: [ :destroy ]
  skip_before_action :verify_authenticity_token
  before_action :load_user_by_jti, only: :destroy

  # before_action :sign_in_params, only: :create
  # before_action :load_user_by_email, only: :create
  # before_action :load_user_by_jti, only: :destroy

  def create
    user = User.find_for_database_authentication(email: sign_in_params[:email])
    if user.nil?
      render json: { message: 'User not found' }, status: :unauthorized
      return
    end

    if user.valid_password?(sign_in_params[:password])
      token = generate_token(user)
      render json: {
        message: 'Login successful',
        token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :ok
    else
      render json: { message: 'Invalid password' }, status: :unauthorized
    end
  end

  def destroy
    if @user
      # Сброс JTI для инвалидации токена
      @user.update_column(:jti, SecureRandom.uuid)
      render json: { message: 'Signed Out Successfully' }, status: :ok
    else
      render json: { message: 'Sign Out Failed - Unauthorized' }, status: :unauthorized
    end
  end

  private

    def sign_in_params
      params.require(:user).permit(:email, :password)
    end

    def load_user_by_jti
      # Извлекаем JTI из токена в заголовке
      jwt = request.headers["Authorization"]&.split(" ").last
      return unless jwt

      decoded_token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, algorithm: 'HS256')
      @user = User.find_by(jti: decoded_token[0]['jti'])
    end

    def load_user_by_email
      @user = User.find_for_database_authentication(email: sign_in_params[:email])
      render_unauthorized unless @user
    end

    def render_unauthorized
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end

    # def encrypt_payload
    #   payload = @user.as_json(only: [:email, :jti])
    #   token = JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
    # end

    # def decrypt_payload
    #   jwt = request.headers["Authorization"]
    #   token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })
    # end

    def generate_token(user)
      payload = {
        user_id: user.id,
        email: user.email,
        jti: user.jti,
        exp: 24.hours.from_now.to_i
      }
      JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
    end

end