json.extract! fandom, :id, :name, :description

json.profile do
  json.name fandom.user.profile.name if fandom.user&.profile
end

