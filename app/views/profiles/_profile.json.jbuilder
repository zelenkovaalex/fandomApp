json.extract! profile, :id, :name, :bio, :avatar, :created_at, :updated_at
json.url profile_url(profile, format: :json)
