json.extract! profile, :id, :name, :nickname, :city, :bio, :avatar, :created_at, :updated_at

json.user do
  json.id profile.user.id
  json.email profile.user.email
end

json.fandoms profile.fandoms do |fandom|
  json.id fandom.id
  json.name fandom.name
end

json.trails profile.trails do |trail|
  json.title trail.title
  json.body trail.body
end