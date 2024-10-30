class Trail < ApplicationRecord
    belongs_to :fandom
    belongs_to :user

    validates :title, presence: true, length: { minimum: 3 }
    validates :fandom_id, presence: true
    validates :body, presence: true, length: { minimum: 10 }
    
    has_many :comments, dependent: :destroy
end
