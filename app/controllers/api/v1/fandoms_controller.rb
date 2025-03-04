class Api::V1::FandomsController < ApplicationController

  def index
    @allFandoms = Fandom.all
  end

  def show
    @allFandoms = Fandom.find(params[:id])
    render 'api/v1/fandoms/show'
  end
end
