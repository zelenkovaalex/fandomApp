class FandomsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource
  before_action :set_fandom, only: [:update, :new, :edit]

  # GET /fandoms or /fandoms.json
  def index
    @categories = Fandom.distinct.pluck(:category)
    @selected_category = params[:category] || @categories.first
    @fandoms = Fandom.where(category: @selected_category)
    @trails = Trail.all.order(created_at: :desc)

    if current_user && current_user.admin?
      @user_trails = @trails
      @other_trails = []
    elsif current_user
      @user_trails = current_user.trails  
      @other_trails = @trails.where(public: true).where.not(id: @user_trails.pluck(:id))  
    else
      @user_trails = []
      @other_trails = @trails.where(public: true)  
    end
    
    @random_trails = Trail.order("RANDOM()").limit(4)

    @all_trails = Trail.order('RANDOM()').limit(32)
    @carousel_page = params[:carousel_page].to_i || 0
    @trails_per_page = 4
    @carousel_trails = @all_trails[@carousel_page * @trails_per_page, @trails_per_page] || []
  end

  # GET /fandoms/1 or /fandoms/1.json
  def show
    @fandom = Fandom.find_by(id: params[:id])
    @trails = @fandom.trails
  end

  # GET /fandoms/new
  def new
    @fandom = Fandom.new
  end

  # GET /fandoms/1/edit
  def edit
  end

  # POST /fandoms or /fandoms.json
  def create
    @fandom = Fandom.new(fandom_params)

    respond_to do |format|
      if @fandom.save
        format.html { redirect_to @fandom, notice: "Fandom was successfully created." }
        format.json { render :show, status: :created, location: @fandom }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fandom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fandoms/1 or /fandoms/1.json
  def update
    respond_to do |format|
      if @fandom.update(fandom_params)
        format.html { redirect_to @fandom, notice: "Fandom was successfully updated." }
        format.json { render :show, status: :ok, location: @fandom }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fandom.errors, status: :unprocessable_entity }
      end
    end
  end

  def show_fandom_trails
    fandom = Fandom.find(params[:id])
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "fandom_#{fandom.id}_trails",
          partial: "fandom_trails",
          locals: { fandom: fandom }
        )
      end
    end
  end

  # DELETE /fandoms/1 or /fandoms/1.json

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fandom
      @fandom = Fandom.where(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fandom_params
      params.require(:fandom).permit(:name, :description)
    end
end
