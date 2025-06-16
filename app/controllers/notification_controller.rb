class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.includes(:notifiable).order(created_at: :desc)
    @notifications.update_all(read: true)
  end

  def update
    @notification = current_user.notifications.find(params[:id])
    @notification.update!(read: true)
    redirect_back(fallback_location: notifications_path)
  end
end