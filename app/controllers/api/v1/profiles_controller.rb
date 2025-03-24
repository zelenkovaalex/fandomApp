class Api::V1::ProfilesController < ApplicationController
  mount_uploader :avatar, AvatarUploader
  before_action :authenticate_user!

  def index
    @profiles = Profile
      .joins(user: [ :trail ])
      .where("trails.status = ?", "active")
      .group("profiles.id")
      .having("COUNT(trails.id) > 0")
      .limit(10)
  end

  def show
    @profile = Profile.find(params[:id])

    rescue ActiveRecord::RecordNotFound 
         redirect_to new_profile_path, alert: "Profile not found. Please create one."
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to profile_url(@profile), notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

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

  def edit
    @profile = Profile.find(params[:id])
    @fandoms = Fandom.all
  end

  def destroy
    @profile.destroy!

    respond_to do |format|
      format.html { redirect_to profiles_url, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_profile
      @profile = Profile.find(params[:id])
    end

  def profile_params
    params.require(:profile).permit(:name, :nickname, :city, :bio, :avatar, fandom_ids: [])
  end

end