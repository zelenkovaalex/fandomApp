json.extract! @fandom, :id, :name, :description

json.set! :trails do
  json.array! @fandom.trails, partial: "api/v1/fandoms/fandom", as: :fandom
end