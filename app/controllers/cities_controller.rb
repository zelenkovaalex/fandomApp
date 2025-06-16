class CitiesController < ApplicationController
  def index
    @cities = YAML.load_file(Rails.root.join('db', 'seeds', 'cities.yml')).map { |city| city["name"] }
  end
end