# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles
  def index
    fields_to_check = [:nickname, :bio, :avatar]
    conditions = fields_to_check.map { |field| "#{field} IS NOT NULL AND #{field} != ''" }.join(' AND ')

    @profiles = Profile
      .joins(user: :trails)
      .where(conditions)
      .group("profiles.id")
      .having("COUNT(trails.id) > 0")
      .limit(10)
  end

  # GET /profiles/:id
  def show
    @trails = @profile.user.trails
    rescue ActiveRecord::RecordNotFound
    redirect_to new_profile_path, alert: "Profile not found. Please create one."
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/:id/edit
  def edit
    @fandoms = Fandom.all
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      redirect_to @profile, notice: "Profile was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profiles/:id
  def update
  Rails.logger.debug "PARAMS: #{params.inspect}"
    if @profile.update(profile_params)
      update_fandoms if params[:profile][:fandom_ids] # Добавляем фандомы

      redirect_to @profile, notice: 'Profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /profiles/:id
  def destroy
    @profile.destroy!
    redirect_to profiles_path, notice: "Profile was successfully deleted."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to profiles_path, alert: "Profile not found." #  Более простой вариант
  end

  # Only allow a list of trusted parameters through.
  def profile_params
    params.require(:profile).permit(:name, :bio, :city, :nickname, :avatar, :link, fandom_ids: [])
  end

  def update_fandoms
    @profile.fandoms.clear # Очищаем существующие фандомы
    params[:profile][:fandom_ids].each do |fandom_id|
      fandom = Fandom.find(fandom_id)
      @profile.fandoms << fandom
      Rails.logger.debug "Added fandom #{fandom.name} to profile #{@profile.id}"
    end
  end
end