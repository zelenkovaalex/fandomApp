class FandomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fandom, only: [:update, :new, :edit]

  # GET /fandoms or /fandoms.json
  def index
    @allFandoms = Fandom.all
    @trails = Trail.all
  end

  # GET /fandoms/1 or /fandoms/1.json
  def show
    @fandom = Fandom.find_by(id: params[:id])
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

  # DELETE /fandoms/1 or /fandoms/1.json

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fandom
      @fandom = Fandom.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fandom_params
      params.require(:fandom).permit(:name, :description)
    end
end