class Api::V1::TrailsController < ApplicationController

  def index
    @trails = Trail.all
    # render json: @trails
    # render json: @trails.as_json
  end

  def show
    @trail = Trail.find(params[:id])
  end
end
