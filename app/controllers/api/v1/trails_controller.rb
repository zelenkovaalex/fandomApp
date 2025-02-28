class Api::V1::TrailsController < ApplicationController

  def index
    @trails = Trail.all
    # render json: @trails
    # render json: @trails.as_json
  end

  def show
    @trail = Trail.find(params[:id])
  end

  def create
    puts 'decrypt_payload'
    puts decrypt_payload
    
    user = User.find_by_jti(decrypt_payload[0]['jti'])
    trail = user.trails.new(trail_params)

    if trail.save
      render json: trail, status: :created
    else
      render json: trail.errors, status: :unprocessable_entity
    end
  end

  def destroy
      @trail.destroy!

      respond_to do |format|
        format.html { redirect_to admin_trails_path, status: :see_other, notice: "trail was successfully destroyed." }
        format.json { head :no_content }
      end
    end

  private

    def trail_params
      params.require(:trail).permit(:title, :trail_image)
    end

    def encrypt_payload
      payload = @user.as_json(only: [:email, :jti])
      token = JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!, 'HS256')
    end

    def decrypt_payload
      jwt = request.headers["Authorization"]
      token = JWT.decode(jwt, Rails.application.credentials.devise_jwt_secret_key!, true, { algorithm: 'HS256' })
    end

end
