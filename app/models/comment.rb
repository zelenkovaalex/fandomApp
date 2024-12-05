class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :trail

  # after_create_commit { broadcast_prepend_to('comments') }

  default_scope { order(created_at: "DESC") }
end