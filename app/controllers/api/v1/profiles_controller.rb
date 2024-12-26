class Api::V1::ProfilesController < ApplicationController
  def index
    @profiles = Profile.all
  end
  
  def community
  end
  
  def show
    @profile = Profile.find(params[:id])
    render 'api/v1/profiles/show' # Render the show view for JSON
  end
end