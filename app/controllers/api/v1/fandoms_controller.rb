class Api::V1::FandomsController < ApplicationController

  def index
    @fandoms = Fandom.all
    @allFandoms = Fandom.all
  end

  def show
    @fandom = Fandom.find_by(id: params[:id])
  end

