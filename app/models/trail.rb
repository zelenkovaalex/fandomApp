class Trail < ApplicationRecord
    belongs_to :fandom
    validates :title, presence: true, length: { minimum: 5 }    
    validates :trail_time, presence: true
    validates :trail_level, presence: true
    validates :body, presence: true

    attr_accessor :fandom_id
end
