json.extract! trail, :id, :title, :city, :body, :duration, :distance, :difficulty, :average_rating, :comments_count, :likes_count, :trail_points

json.price trail.price

json.cover_image trail.cover_image

json.fandom do
  json.id trail.fandom.id
  json.name trail.fandom.name
end

json.trail_points trail.trail_points do |point|
  json.id point.id
  json.name point.name
  json.description point.description
  json.map_link point.map_link
  json.image_url point.image_url
end

json.comments trail.comments do |comment|
  json.partial! "api/v1/trails/comment", comment: comment
end