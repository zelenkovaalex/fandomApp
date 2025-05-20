class Rating < ApplicationRecord
  belongs_to :trail
  belongs_to :user

  validates :value, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :trail_id, message: "can only rate a trail once" }
end
