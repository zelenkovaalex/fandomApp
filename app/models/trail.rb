class Trail < ApplicationRecord
    belongs_to :fandom
    belongs_to :user

    validates :title, presence: true, length: { minimum: 3 }
    validates :fandom_id, presence: true
    validates :body, presence: true, length: { minimum: 10 }
    
    has_many :comments, dependent: :destroy
    has_many :likes, as: :likeable

    acts_as_taggable_on :tags
    acts_as_taggable_on :categories

    default_scope { order(created_at: "DESC") }
end
