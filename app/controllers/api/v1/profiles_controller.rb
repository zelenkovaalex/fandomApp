class Api::V1::ProfilesController < ApplicationController

  # def index
  #   @profiles = Profile.all
  # end
  
  def show
    @profile = Profile.find(params[:id])
    render 'api/v1/profiles/show' 
  end

end