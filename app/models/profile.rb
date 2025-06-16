class Profile < ApplicationRecord
    belongs_to :user

    has_and_belongs_to_many :fandoms

    # serialize :fandom_names, Array

    has_many :trails, dependent: :destroy
    
    has_many :created_trails, class_name: 'Trail'
    
    default_scope { order(created_at: "DESC") }
    
    has_one_attached :avatar
    mount_uploader :avatar, AvatarUploader

    before_save :log_profile

    validates :city, inclusion: { in: ->(_) { YAML.load_file(Rails.root.join('db', 'seeds', 'cities.yml')) } }

    def log_profile
        Rails.logger.debug "Profile before save: #{self.inspect}"
    end

    def fandoms
        Fandom.where(name: fandom_names)
    end

    def fandom_names
        read_attribute(:fandom_names) || []
    end

end
