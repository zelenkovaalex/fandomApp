json.array! @profiles do |profile|
    json.extract! profile, :user_id, :name, :nickname, :fandom_id, :bio, :city
end