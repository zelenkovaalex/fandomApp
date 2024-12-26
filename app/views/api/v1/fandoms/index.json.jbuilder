json.array! @fandoms do |fandom|
  json.extract! fandom, :id, :name, :description
end