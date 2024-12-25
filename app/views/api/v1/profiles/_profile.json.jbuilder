json.extract! profile, :user_id, :name, :nickname, :fandom_id, :bio, :city
json.user do
  json.email profile.user.email
end
json.url profile_url(profile)
