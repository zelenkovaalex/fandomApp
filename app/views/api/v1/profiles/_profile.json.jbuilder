json.extract! profile, :user_id, :nickname, :fandom_id, :bio, :city, :trail
json.user do
  json.email profile.user.email
end
json.url profile_url(profile)
