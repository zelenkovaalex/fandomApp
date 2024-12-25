class Api::V1::ProfilesController < ApplicationController
  def index
    @profiles = Profile.all
  end
  
  def community
  end
  
  def show
  end