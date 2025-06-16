class SearchController < ApplicationController
  def index
    @query = params[:query]

    if @query.present?
      if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
        # Use ILIKE for PostgreSQL
        @trails = Trail.where("title ILIKE :query OR body ILIKE :query", query: "%#{@query}%")
        @profiles = Profile.where("nickname ILIKE :query", query: "%#{@query}%")
        @fandoms = Fandom.where("name ILIKE :query", query: "%#{@query}%")
      else
        # Use LOWER for SQLite
        @trails = Trail.where("LOWER(title) LIKE :query OR LOWER(body) LIKE :query", query: "%#{@query.downcase}%")
        @profiles = Profile.where("LOWER(nickname) LIKE :query", query: "%#{@query.downcase}%")
        @fandoms = Fandom.where("LOWER(name) LIKE :query", query: "%#{@query.downcase}%")
      end
    end

    respond_to do |format|
      format.json {
        render json: {
          trails: @trails.as_json(only: [:id, :title]),
          profiles: @profiles.as_json(only: [:id, :nickname]),
          fandoms: @fandoms.as_json(only: [:id, :name])
        }
      }
      format.html
      format.turbo_stream
    end
  end
end