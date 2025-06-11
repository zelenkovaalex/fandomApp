class Profile < ApplicationRecord
    belongs_to :user

    has_and_belongs_to_many :fandoms, through: :fandoms_profiles

    has_many :trails, dependent: :destroy
    
    has_many :created_trails, class_name: 'Trail'
    
    default_scope { order(created_at: "DESC") }
    
    has_one_attached :avatar
    mount_uploader :avatar, AvatarUploader

    before_save :log_profile

    def log_profile
        Rails.logger.debug "Profile before save: #{self.inspect}"
    end

    def fandoms
        Fandom.where(name: fandom_names)
    end

end
