class TrailsController < ApplicationController
  # before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_fandom

  def index
    @trails = Trail.all.order(created_at: :desc)

    if current_user && current_user.admin?
      @user_trails = @trails
      @other_trails = []
    elsif current_user
      @user_trails = current_user.trails
      @other_trails = @trails.where(public: true).where.not(id: @user_trails.pluck(:id))
      @trails = (@user_trails + @other_trails).uniq # Соберите все маршруты в @trails и удалите дубликаты
    else
      @user_trails = []
      @other_trails = @trails.where(public: true)
      @trails = @other_trails # Соберите все маршруты в @trails
    end
  end

  def by_tag
    @trails = params[:tag] ? Trail.tagged_with(params[:tag]) : Trail.all
    render :index
  end

  def show
    Rails.logger.debug "Params: #{params.inspect}"
    Rails.logger.debug "Trail: #{@trail.inspect}"
    if @trail.nil?
      Rails.logger.error "Trail with id #{params[:id]} not found!"
      redirect_to trails_path, alert: "Маршрут не найден."
      return
    end
  end

  def new
    @trail = Trail.new # Не нужно, load_and_authorize_resource уже создает новый маршрут
  end

  def edit
  end

  def create
    @trail = current_user.trails.new(trail_params)
    @trail.user = current_user

    respond_to do |format|
      if @trail.save
        format.html { redirect_to @trail, notice: "Trail was successfully created." }
        format.json { render :show, status: :created, location: @trail }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trail.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @trail.update(trail_params)
        format.html { redirect_to trail_path(@trail), notice: "trail was successfully updated." }
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
      format.html { redirect_to trails_path, status: :see_other, notice: "trail was successfully destroyed." } # или fandom_trails_path(@fandom)
      format.json { head :no_content }
    end
  end

  private

  def set_fandom
    @fandom = Fandom.find(params[:fandom_id]) if params[:fandom_id]
  end

  def trail_params
    params.require(:trail).permit(:title, :description, :trail_image, :trail_time, :trail_level, :fandom_id, :tag_list)
  end
end