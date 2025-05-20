class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :trail

  validates :body, presence: true
  validates :rating_value, inclusion: { in: 1..5 }, allow_nil: true

  has_many :replies, class_name: "Comment", foreign_key: "comment_id", dependent: :destroy
  belongs_to :comment, optional: true

  default_scope { order(created_at: "DESC") }
  scope :no_replies, -> { where(comment_id: nil) }

  after_create_commit { broadcast_prepend_to("comments") }
end
