class Trail < ApplicationRecord
    belongs_to :fandom
    belongs_to :user
    belongs_to :profile

    validates :title, presence: true, length: { minimum: 3 }
    validates :fandom_id, presence: true
    validates :body, presence: true, length: { minimum: 10 }
    validates :user, presence: true
    
    has_many :comments, dependent: :destroy
    has_many :likes, as: :likeable

    acts_as_taggable_on :tags
    acts_as_taggable_on :fandoms

    has_many :tag_selecteds
    has_many :tags, through: :tag_selecteds 

    has_one_attached :trail_image
    mount_uploader :trail_image, TrailImageUploader

    default_scope { order(created_at: "DESC") }
end
