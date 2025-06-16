class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification_type
      t.references :notifiable, polymorphic: true, null: false
      t.boolean :read, default: false
      t.json :data

      t.timestamps
    end
  end
end