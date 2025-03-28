class LikeController < ApplicationController
  before_action :authenticate_user!

  def toggle
    unless params[:trail_id].present?
      return render json: { success: false, error: 'Trail ID is missing' }, status: :unprocessable_entity
    end

    @trail = Trail.find_by(id: params[:trail_id])
    unless @trail
      return render json: { success: false, error: 'Trail not found' }, status: :not_found
    end

    if current_user.liked?(@trail)
      current_user.unlike(@trail)
      liked = false
    else
      current_user.like(@trail)
      liked = true
    end

    respond_to do |format|
      format.json { render json: { success: true, liked: liked } }
    end
  end
end