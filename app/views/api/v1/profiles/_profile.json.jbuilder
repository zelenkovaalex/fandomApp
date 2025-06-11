json.extract! profile, :id, :nickname, :city, :bio, :link, :jwt, :fandom_names
json.avatar url_for(profile.avatar) if profile.avatar.attached?
json.user do
  json.id profile.user.id
  json.email profile.user.email
end
json.fandoms profile.fandoms do |fandom|
  json.id fandom.id
  json.name fandom.name
end
json.trails profile.trails do |trail|
  json.id trail.id
  json.title trail.title
  json.body trail.body
  json.duration trail.duration
  json.distance trail.distance
  json.difficulty trail.difficulty
  json.average_rating trail.average_rating
  json.comments_count trail.comments.count
  json.likes_count trail.likes.count
  json.trail_points trail.trail_points do |point|
    json.id point.id
    json.name point.name
    json.description point.description
    json.image_url url_for(point.image_url) if point.image_url.attached?
    json.latitude point.latitude
    json.longitude point.longitude
    json.map_link point.map_link
  end
end