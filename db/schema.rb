# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_06_23_101601) do
  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "user_id", null: false
    t.integer "trail_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comment_id"
    t.integer "rating_value"
    t.index ["trail_id"], name: "index_comments_on_trail_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "fandoms", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "category"
    t.index ["name"], name: "index_fandoms_on_name", unique: true
  end

  create_table "fandoms_profiles", id: false, force: :cascade do |t|
    t.integer "fandom_id"
    t.integer "profile_id"
    t.index ["fandom_id", "profile_id"], name: "index_fandoms_profiles_on_fandom_id_and_profile_id", unique: true
    t.index ["fandom_id"], name: "index_fandoms_profiles_on_fandom_id"
    t.index ["profile_id"], name: "index_fandoms_profiles_on_profile_id"
  end

  create_table "favourites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "trail_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trail_id"], name: "index_favourites_on_trail_id"
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "finished_trails", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "trail_id", null: false
    t.datetime "finished_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trail_id"], name: "index_finished_trails_on_trail_id"
    t.index ["user_id", "trail_id"], name: "index_finished_trails_on_user_id_and_trail_id", unique: true
    t.index ["user_id"], name: "index_finished_trails_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.string "likeable_type"
    t.integer "likeable_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "notification_type"
    t.string "notifiable_type", null: false
    t.integer "notifiable_id", null: false
    t.boolean "read", default: false
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "bio"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
    t.string "nickname"
    t.string "link"
    t.text "fandom_names"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "trail_id", null: false
    t.decimal "price", precision: 10, scale: 2
    t.string "status", default: "pending"
    t.datetime "purchased_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trail_id"], name: "index_purchases_on_trail_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tag_selecteds", force: :cascade do |t|
    t.integer "trail_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_tag_selecteds_on_tag_id"
    t.index ["trail_id"], name: "index_tag_selecteds_on_trail_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "trail_points", force: :cascade do |t|
    t.integer "trail_id", null: false
    t.string "name"
    t.text "description"
    t.string "image"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "map_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trail_id"], name: "index_trail_points_on_trail_id"
  end

  create_table "trails", force: :cascade do |t|
    t.string "title"
    t.json "fandom"
    t.string "trail_time"
    t.string "trail_level"
    t.text "body"
    t.string "fandom_id"
    t.integer "duration"
    t.string "duration_unit"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: false
    t.string "city"
    t.integer "profile_id", null: false
    t.string "image"
    t.integer "distance"
    t.string "difficulty"
    t.integer "likes_count", default: 0
    t.integer "comments_count", default: 0
    t.decimal "price", precision: 10, scale: 2
    t.index ["profile_id"], name: "index_trails_on_profile_id"
    t.index ["user_id"], name: "index_trails_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.string "jti"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "trails"
  add_foreign_key "comments", "users"
  add_foreign_key "fandoms_profiles", "fandoms"
  add_foreign_key "fandoms_profiles", "profiles"
  add_foreign_key "favourites", "trails"
  add_foreign_key "favourites", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "purchases", "trails"
  add_foreign_key "purchases", "users"
  add_foreign_key "tag_selecteds", "tags"
  add_foreign_key "tag_selecteds", "trails"
  add_foreign_key "taggings", "tags"
  add_foreign_key "trail_points", "trails"
  add_foreign_key "trails", "profiles"
  add_foreign_key "trails", "users"
end
