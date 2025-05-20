json.extract! fandom, :id, :name

json.trails fandom.trails do |trail|
  json.id trail.id
  json.title trail.title
  json.body trail.body
  json.duration trail.duration
  json.distance trail.distance
  json.difficulty trail.difficulty
  json.average_rating trail.average_rating
  json.comments_count trail.comments.count
  json.likes_count trail.likes.count
end