class Profile < ApplicationRecord
    include PgSearch::Model
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

    pg_search_scope :search_by_name_and_bio,
    against: { nickname: 'A', bio: 'B' },
    using: {
      tsearch: { prefix: true }
    }
    
    def log_profile
        Rails.logger.debug "Profile before save: #{self.inspect}"
    end

    def fandoms
        Fandom.where(name: fandom_names)
    end

    def fandom_names
        self[:fandom_names] || []
    end

    def fandom_names=(names)
        self[:fandom_names] = names.split(",").map(&:strip)
    end

end
