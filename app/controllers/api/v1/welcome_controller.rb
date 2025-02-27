class Api::V1::WelcomeController < ApplicationController

  def index
    @trails = Trail.last(10)
    @comments = Comment.last(10)
  end

end