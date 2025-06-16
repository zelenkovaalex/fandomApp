class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true

  scope :unread, -> { where(read: false) }

  after_create_commit do
    broadcast_replace_later_to(
      "notifications_#{user_id}",
      target: "notification_count",
      partial: "notifications/notification_count",
      locals: { user: user }
    )
  end
end