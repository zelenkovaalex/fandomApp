class Admin::TrailsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_trail, only: [:update, :destroy, :edit, :new, :show]

  # GET /trails or /trails.json
  def index
    @trails = Trail.all
  end


  def by_tag
      @trails = Trail.tagged_with(params[:tag])

      render :index
  end

  # GET /trails/1 or /trails/1.json
  def show
    @trail = Trail.where(params[:id])
  end

  # GET /trails/new
  def new
    @trail = Trail.new
  end

  # GET /trails/1/edit
  def edit
  end

  # trail /trails or /trails.json
  def create
    @trail = current_user.trails.new(trail_params)

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

  # PATCH/PUT /trails/1 or /trails/1.json
  def update
    respond_to do |format|
      if @trail.update(trail_params)
        format.html { redirect_to @trail, notice: "Trail was successfully updated." }
        format.json { render :show, status: :ok, location: @trail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trails/1 or /trails/1.json
  def destroy
    @trail.destroy!

    respond_to do |format|
      format.html { redirect_to trails_path, status: :see_other, notice: "Trail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trail
      @trail = Trail.where(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trail_params
      params.require(:trail).permit(:title, :description, :trail_image, :trail_time, :trail_level, :fandom_id)
    end
end