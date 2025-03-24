class Admin::ProfilesController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource
  before_action :set_profile, only: %i[ show edit update destroy ]

  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
  end
  
  def community
  end
  
  # GET /profiles/1 or /profiles/1.json
  def show
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
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])
    @fandoms = Fandom.all
  end

  # POST /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    @profile = Profile.find(params[:id])
    if @profile.update(profile_params)
      # Добавляем фандомы
      if params[:profile][:fandom_ids]
        params[:profile][:fandom_ids].each do |fandom_id|
          fandom = Fandom.find(fandom_id)
          @profile.fandoms << fandom
          Rails.logger.debug "Added fandom #{fandom.name} to profile #{@profile.id}"
        end
      end
      redirect_to @profile, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    @profile = Profile.find(params[:id])
    authorize! :destroy, @profile

    @profile.destroy!

    redirect_to profiles_path, notice: "Profile was successfully deleted."
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Profile not found."
    redirect_to profiles_path
  rescue CanCan::AccessDenied
    flash[:alert] = "You are not authorized to delete this profile."
    redirect_to profiles_path
  rescue => e
    flash[:alert] = "An error occurred: #{e.message}"
    redirect_to profiles_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:name, :bio, :avatar)
    end
end