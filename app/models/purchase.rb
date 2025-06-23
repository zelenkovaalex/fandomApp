class Purchase < ApplicationRecord
  belongs_to :user
  belongs_to :trail

  validates :user_id, uniqueness: { scope: :trail_id }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending completed failed] }
  def complete!
    update(status: "completed", purchased_at: Time.current)
  end

  def fail!
    update(status: "failed")
  end
end
