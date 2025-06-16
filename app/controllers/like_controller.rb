class LikeController < ApplicationController
  before_action :authenticate_user!

  def create
    likeable = params[:likeable_type].constantize.find(params[:likeable_id])
    like = current_user.likes.find_or_initialize_by(likeable: likeable)

    if like.new_record?
      like.save
      render json: { success: true, liked: true }, status: :created
    else
      like.destroy
      render json: { success: true, liked: false }, status: :ok
    end
  end

  def toggle
    @trail = Trail.find(params[:trail_id])
    like = current_user.likes.find_by(likeable: @trail)

    if like
      like.destroy
      liked = false
    else
      like = current_user.likes.create!(likeable: @trail)
      liked = true

      # Create notification for the trail's author (unless the liker is the author)
      if @trail.user != current_user
        Notification.create!(
          user: @trail.user,
          notifiable: like,
          notification_type: "like",
          data: { trail_title: @trail.title, liker: current_user.nickname }
        )
      end
    end

    respond_to do |format|
      format.turbo_stream
      format.json { render json: { success: true, liked: liked } }
    end
  end
end