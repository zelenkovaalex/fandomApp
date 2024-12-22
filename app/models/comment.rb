class Comment < ApplicationRecord
  belongs_to :trail
  belongs_to :user

  validates :body, presence: true

  has_many :replies, class_name: "Comment", foreign_key: "comment_id", dependent: :destroy
  belongs_to :comment, optional: true

  default_scope { order(created_at: "DESC") }
  scope :no_replies, -> { where(comment_id: nil) }

  after_create_commit { broadcast_prepend_to("comments") }
end
