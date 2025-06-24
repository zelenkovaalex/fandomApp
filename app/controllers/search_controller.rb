class SearchController < ApplicationController
  def index
    @query = params[:q]

    if @query.present?
      @profiles = Profile.search_by_name_and_bio(@query)
      @fandoms = Fandom.search_by_title_and_description(@query)
      @trails = Trail.search_by_title_and_body(@query)
    else
      @profiles = []
      @fandoms = []
      @trails = []
    end
  end
end