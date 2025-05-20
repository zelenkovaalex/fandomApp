class Api::V1::ProfilesController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_profile, only: [:show, :update, :destroy]

  def index
    @profiles = Profile.all.includes(:user, :trails)
    Rails.logger.info "Loaded profiles: #{@profiles.inspect}"
    render json: @profiles, include: [:user, :trails], status: :ok
  end

  def show
    @profile = Profile.includes(:user, :trails).find_by(id: params[:id])
    if @profile
      Rails.logger.info "Loaded profile: #{@profile.inspect}"
      render json: @profile, include: [:user, :trails], status: :ok
    else
      render json: { error: "Profile not found" }, status: :not_found
    end
  end

  def update
    profile = Profile.find_by(id: params[:id])
    params[:profile][:fandom_names] = params[:profile][:fandom_names].split(",").map(&:strip)
    if profile && profile.update(profile_params)
      render json: profile, status: :ok
    else
      render json: { error: "Failed to update profile" }, status: :unprocessable_entity
    end
  end

  def destroy
    @profile.destroy!
    head :no_content
  end

  private

  def set_profile
    @profile = Profile.find_by(id: params[:id])
    unless @profile
      render json: { error: "Profile not found" }, status: :not_found
    end
  end

  def profile_params
    params.require(:profile).permit(:name, :bio, :city, :nickname, :avatar, :link, fandom_ids: [])
  end

end