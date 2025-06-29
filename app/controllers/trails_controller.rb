class TrailsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_fandom
  before_action :set_trail, only: [:show, :update, :destroy]

  def index
    @trail = Trail.find(params[:id])
    @active_menu_item = :home

    @trails = Trail.all.order(created_at: :desc)

    if current_user && current_user.admin?
      @user_trails = @trails
      @other_trails = []
    elsif current_user
      @user_trails = current_user.trails
      @other_trails = @trails.where(public: true).where.not(id: @user_trails.pluck(:id))
      @trails = (@user_trails + @other_trails).uniq
    else
      @user_trails = []
      @other_trails = @trails.where(public: true)
      @trails = @other_trails
    end
  end

  def by_tag
    @trails = Trail.tagged_with(params[:tag], on: :fandoms)
    render :index
  end

  def like
    trail = Trail.find(params[:id])
    if current_user.liked?(trail)
      current_user.unlike(trail)
    else
      current_user.like(trail)
    end

    respond_to do |format|
      format.json { render json: { success: true, liked: current_user.liked?(trail) } }
    end
  end

  def show
    @trail_points = @trail.trail_points
    unless can_view_trail?(@trail)
      redirect_to purchase_trail_path(@trail), alert: "You need to purchase this trail to view it."
      return
    end
    respond_to do |format|
      format.html
      format.turbo_stream
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "image-grid",
          partial: "trails/image_grid",
          locals: { trail_points: @trail_points }
        )
      end
    end
  end

  def purchase
    @trail = Trail.find(params[:id])
    # Render payment form
  end

  def pay
    @trail = Trail.find(params[:id])
    # Here you would process payment info (params[:card_number], etc.)
    # For now, just simulate success:
    purchase = current_user.trail_purchases.create!(trail: @trail)

    # Notify the trail's author
    if @trail.user != current_user
      Notification.create!(
        user: @trail.user,
        notifiable: purchase,
        notification_type: "purchase",
        data: { trail_title: @trail.title, buyer: current_user.nickname }
      )
    end

    # Notify the buyer
    Notification.create!(
      user: current_user,
      notifiable: purchase,
      notification_type: "bought",
      data: { trail_title: @trail.title }
    )

    redirect_to thank_you_trail_path(@trail)
  end

  def thank_you
    @trail = Trail.find(params[:id])
  end

  def new
    @trail = Trail.new
    2.times { @trail.trail_points.build }
  end

  def create
    @step = params[:step] || "main"
    @trail = current_user.trails.new(trail_params)
    @trail.profile = current_user.profile

    if @step == "main"
      if @trail.valid?
        render turbo_stream: turbo_stream.replace(
          "trail-form",
          partial: "admin/trails/form_points",
          locals: { trail: @trail }
        )
      else
        render turbo_stream: turbo_stream.replace(
          "trail-form",
          partial: "admin/trails/form",
          locals: { trail: @trail }
        )
      end
    else # step == "points"
      if @trail.save
        redirect_to @trail, notice: "Маршрут успешно создан."
      else
        render turbo_stream: turbo_stream.replace(
          "trail-form",
          partial: "admin/trails/form_points",
          locals: { trail: @trail }
        )
      end
    end
  end

  def update
    respond_to do |format|
      if @trail.update(trail_params)
        format.html { redirect_to @trail, notice: "Маршрут успешно обновлен." }
        format.json { render :show, status: :ok, location: @trail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trail.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @trail.destroy!
    respond_to do |format|
      format.html { redirect_to trails_path, status: :see_other, notice: "trail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def can_view_trail?(trail)
    current_user&.admin? || trail.user == current_user || current_user&.purchased_trails&.exists?(trail.id)
  end

  def set_trail
    @trail = Trail.find(params[:id])
  end

  def set_fandom
    @fandom = Fandom.find(params[:fandom_id]) if params[:fandom_id]
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
      trail_points_attributes: [:id, :name, :description, :map_link, :image_url, :_destroy],
      gallery_attributes: [:id, images: []]
    )
  end
end