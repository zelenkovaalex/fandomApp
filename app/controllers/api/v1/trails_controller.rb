class Api::V1::TrailsController < ApplicationController
  before_action :set_trail, only: [:show]

  def index
    @trails = Trail.all
    # render json: @trails
    # render json: @trails.as_json
  end

  def show
    render json: {
      id: @trail.id,
      title: @trail.title,
      body: @trail.body,
      average_rating: @trail.average_rating,
      comments_count: @trail.comments.count,
      positive_ratings_percentage: @trail.positive_ratings_percentage,
      ratings: @trail.ratings_with_users
    }
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

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @trail.destroy!

    respond_to do |format|
      format.html { redirect_to admin_trails_path, status: :see_other, notice: "trail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def purchase
    trail = Trail.find(params[:id])
    if trail.price > 0
      purchase = current_user.purchases.build(trail: trail, price: trail.price, status: "pending")
      if purchase.save
        purchase.complete!
        render json: { message: "Trail purchased successfully", purchase: purchase }, status: :ok
      else
        render json: { error: "Failed to purchase trail", details: purchase.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Trail is not available for purchase" }, status: :unprocessable_entity
    end
  end

  private

    def set_trail
      @trail = Trail.find(params[:id])
    end

    def trail_params
      params.require(:trail).permit(
        :title,
        :body,
        :image,
        :duration,
        :duration_unit,
        :trail_level,
        :fandom_id,
        trail_points_attributes: [:id, :name, :description, :image_url, :latitude, :longitude, :_destroy]
      )
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
