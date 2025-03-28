class Api::V1::SessionsController < Devise::SessionsController
  # skip_before_action :require_no_authentication, only: [:create]
  skip_before_action :verify_authenticity_token

  def create
    user = User.find_by(email: params[:email])
    # user = User.find_for_database_authentication(email: params[:email])
    if user&.valid_password?(params[:password])
      token = generate_token(user)
      render json: {
        message: 'Login successful',
        # token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    render json: {
        messages: "Signed Out Successfully",
        is_success: true
      }, status: :ok
    # @user = User.find_by_jti(decrypt_payload[0]['jti'])

    # if @user && @user.update_column(:jti, SecureRandom.uuid)
    #   render json: {
    #     messages: "Signed Out Successfully",
    #     is_success: true
    #   }, status: :ok
    # else
    #   render json: {
    #     messages: "Sign Out Failed - Unauthorized",
    #     is_success: false
    #   }, status: :unauthorized
    # end
  end

  private

    def sign_in_params
      params.require(:user).permit(:email, :password)
    end

    def load_user
      @user = User.find_for_database_authentication(email: sign_in_params[:email])

      unless @user
        render json: {
          messages: "Sign In Failed - Unauthorized",
          is_success: false
        }, status: :unauthorized
      end
    end

    def encrypt_payload
      payload = @user.as_json(only: [:email, :jti])
      token = JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
    end

    def decrypt_payload
      jwt = request.headers["Authorization"]
      token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })
    end

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