class Api::V1::FandomsController < ApplicationController

  def index
    @fandoms = Fandom.all
    @allFandoms = Fandom.all
  end

  def show
    @fandom = Fandom.find(params[:id])
    render 'api/v1/fandoms/show' # Render the show view for JSON
  end
end
