class Profile < ApplicationRecord
    belongs_to :user
    belongs_to :fandom, optional: true
    
    has_many :created_trails, class_name: 'Trail'

    # mount_uploader :avatar, AvatarUploader

    default_scope { order(created_at: "DESC") }
end
