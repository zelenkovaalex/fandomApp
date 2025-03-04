class Api::V1::FandomsController < ApplicationController

  def index
    @fandoms = Fandom.all
  end

  def show
    @fandom = Fandom.find(params[:id])
  end
end
