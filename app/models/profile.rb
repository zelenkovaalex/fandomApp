class Profile < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :fandom, optional: true
    
    has_many :created_trails, class_name: 'Trail'

    mount_uploader :avatar, AvatarUploader

    default_scope { order(created_at: "DESC") }
end
