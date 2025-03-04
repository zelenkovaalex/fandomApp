class Api::V1::ProfilesController < ApplicationController

  def index
    @profiles = Profile
      .joins(user: [ :trail ])
      .where("trails.status = ?", "active")
      .group("profiles.id")
      .having("COUNT(trails.id) > 0")
      .limit(10)
  end

  def show
  end

end