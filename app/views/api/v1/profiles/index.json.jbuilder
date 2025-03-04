json.array! @profiles do |profile|
  json.id profile.id  # Добавляем id
  json.user_id profile.user_id
  json.nickname profile.nickname
  json.fandom_id profile.fandom_id
  json.bio profile.bio
  json.city profile.city
  json.trail profile.trail
end