class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles
  def index
    fields_to_check = [:nickname, :bio, :avatar]
    conditions = fields_to_check.map { |field| "#{field} IS NOT NULL AND #{field} != ''" }.join(' AND ')

    @cities = Profile.distinct.pluck(:city).compact
    @fandoms = Fandom.all.pluck(:name)

    @cities = YAML.load_file(Rails.root.join('db', 'seeds', 'cities.yml'))
    @profiles = if params[:filter]&.start_with?('city-')
                  city_name = params[:filter].sub('city-', '')
                  Profile.where(city: city_name)
                else
                  Profile.all
                end

    @profiles = Profile.includes(:user).all
      .joins(user: :trails)
      .where(conditions)
      .group("profiles.id")
      .having("COUNT(trails.id) > 0")

    if params[:filter].present?
      if params[:filter].start_with?('city-')
        city = params[:filter].sub('city-', '')
        @profiles = @profiles.where(city: city)
      elsif params[:filter].start_with?('fandom-')
        fandom = params[:filter].sub('fandom-', '')
        @profiles = @profiles.joins(:fandoms).where(fandoms: { name: fandom }).distinct
      end
    end

    @profiles = @profiles.limit(10)
  end

  def filter
    filter = params[:filter]
    if filter.present?
      if filter.start_with?('city-')
        city = filter.sub('city-', '')
        @profiles = Profile.where(city: city)
      elsif filter.start_with?('fandom-')
        fandom = filter.sub('fandom-', '')
        @profiles = Profile.joins(:fandoms).where(fandoms: { name: fandom }).distinct
      else
        @profiles = Profile.all
      end
    else
      @profiles = Profile.all
    end

    respond_to do |format|
      format.turbo_stream
      format.html { render partial: 'profiles/profiles_list', locals: { profiles: @profiles } }
    end
  end

  # GET /profiles/:id
  def show
    @tab = params[:tab] || 'my_trails'
    sort_order = params[:sort] == "asc" ? :asc : :desc

    @trails = case @tab
      when 'my_trails'
        @profile.user.trails.order(created_at: sort_order)
      when 'finished'
        @profile.user.finished_trails.order(created_at: sort_order)
      when 'favourites'
        @profile.user.favourite_trails.order(created_at: sort_order)
      when 'bought'
        @profile.user.purchased_trails.order(created_at: sort_order)
      else
        @profile.user.trails.order(created_at: sort_order)
      end

    # Количество публикаций
    @trails_count = @trails.count

    # Уникальные города, где есть маршруты пользователя
    @cities = @trails.map(&:city).uniq.compact

    # Уникальные фандомы, к которым принадлежат маршруты пользователя
    @fandoms = @trails.map(&:fandom).uniq.compact
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
    @profile = current_user.profile
    Rails.logger.debug "PARAMS: #{params.inspect}"
    params[:profile][:fandom_names] = params[:profile][:fandom_names].split(",").map(&:strip)

    if @profile.update(profile_params)
      update_fandoms if params[:profile][:fandom_ids]

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
    params.require(:profile).permit(
      :name,
      :bio,
      :avatar,
      :city,
      :nickname,
      :fandom_names,
      :link
    )
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