# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_03_154245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.datetime "event_time"
    t.string "google_placeID"
    t.string "location_name"
    t.string "location_address"
    t.integer "difficulty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attendees_count", default: 0
    t.decimal "latitude"
    t.decimal "longitude"
    t.integer "absentees_count", default: 0
    t.integer "reports_count"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "activity_streaks", force: :cascade do |t|
    t.date "date"
    t.bigint "user_id"
    t.boolean "is_activity_done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activity_streaks_on_user_id"
  end

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "blocks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "blocked_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_id"], name: "index_blocks_on_blocked_id"
    t.index ["user_id"], name: "index_blocks_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_type"
    t.integer "reports_count", default: 0
    t.index ["owner_id"], name: "index_comments_on_owner_id"
    t.index ["owner_type"], name: "index_comments_on_owner_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "user_id"
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id"], name: "index_follows_on_follower_id"
    t.index ["user_id", "follower_id"], name: "index_follows_on_user_id_and_follower_id", unique: true
    t.index ["user_id"], name: "index_follows_on_user_id"
  end

  create_table "group_admins", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_admins_on_group_id"
    t.index ["user_id"], name: "index_group_admins_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.string "location"
    t.text "description"
    t.boolean "public", default: true
    t.integer "members_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "topics_count", default: 0
    t.integer "reports_count", default: 0
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "invites", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.integer "invited_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_invites_on_group_id"
    t.index ["invited_by_id"], name: "index_invites_on_invited_by_id"
    t.index ["user_id"], name: "index_invites_on_user_id"
  end

  create_table "join_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_join_requests_on_group_id"
    t.index ["user_id"], name: "index_join_requests_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "owner_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_type"
    t.index ["owner_id"], name: "index_likes_on_owner_id"
    t.index ["owner_type"], name: "index_likes_on_owner_type"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "logins", force: :cascade do |t|
    t.integer "user_id"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "location"
    t.index ["user_id"], name: "index_logins_on_user_id"
  end

  create_table "master_services", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.string "professional_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_members_on_group_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "user_id"
    t.text "body"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "messageable_type", default: "Text", null: false
    t.integer "messageable_id"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "actor_id"
    t.bigint "creator_id"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.integer "action", null: false
    t.boolean "is_seen", default: false, null: false
    t.boolean "is_deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["creator_id"], name: "index_notifications_on_creator_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "activity_id"
    t.bigint "user_id"
    t.boolean "is_attending", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_participants_on_activity_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "post_tagged_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_tagged_users_on_post_id"
    t.index ["user_id"], name: "index_post_tagged_users_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "background"
    t.text "text"
    t.string "font"
    t.string "color"
    t.float "textview_position_x"
    t.float "textview_position_y"
    t.float "textview_rotation"
    t.decimal "latitude"
    t.decimal "longitude"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "font_size"
    t.float "textview_width"
    t.float "textview_height"
    t.string "header_color"
    t.integer "likes_count", default: 0
    t.integer "views_count", default: 0
    t.integer "comments_count", default: 0
    t.float "image_rotation"
    t.float "image_position_x"
    t.float "image_position_y"
    t.float "image_width"
    t.float "image_height"
    t.string "media_url", null: false
    t.float "score", default: 0.0
    t.integer "reports_count"
    t.index ["latitude", "longitude"], name: "index_posts_on_latitude_and_longitude"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "professional_application_submissions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "reviewer_id"
    t.integer "application_status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewer_id"], name: "index_professional_application_submissions_on_reviewer_id"
    t.index ["user_id"], name: "index_professional_application_submissions_on_user_id"
  end

  create_table "professional_service_lengths", force: :cascade do |t|
    t.decimal "length"
    t.decimal "price"
    t.bigint "professional_service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["professional_service_id"], name: "index_professional_service_lengths_on_professional_service_id"
  end

  create_table "professional_services", force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "user_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_professional_services_on_service_id"
    t.index ["user_id"], name: "index_professional_services_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_reports_on_owner_type_and_owner_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "reviewer_id"
    t.integer "user_id"
    t.integer "stars"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "service_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "professional_id"
    t.bigint "professional_service_length_id"
    t.string "details"
    t.string "delivery_method"
    t.string "phone"
    t.string "email"
    t.datetime "time"
    t.decimal "price", default: "0.0", null: false
    t.integer "service_request_status", default: 0
    t.boolean "is_custom", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["professional_id"], name: "index_service_requests_on_professional_id"
    t.index ["professional_service_length_id"], name: "index_service_requests_on_professional_service_length_id"
    t.index ["user_id"], name: "index_service_requests_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.string "professional_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.text "body"
    t.integer "likes_count", default: 0
    t.integer "comments_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "anonymous", default: false
    t.integer "reports_count", default: 0
    t.index ["group_id"], name: "index_topics_on_group_id"
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "provider"
    t.string "uid"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.date "birthdate"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "activation_digest"
    t.boolean "activated", default: false, null: false
    t.integer "failed_attempts", default: 0
    t.string "unlock_digest"
    t.datetime "locked_at"
    t.integer "follower_count", default: 0
    t.integer "following_count", default: 0
    t.boolean "professional", default: false
    t.string "professional_type", default: "None"
    t.text "bio"
    t.integer "reviews_count", default: 0
    t.decimal "rating"
    t.string "license_number"
    t.string "facebook_link"
    t.string "instagram_link"
    t.string "twitter_link"
    t.integer "activity_streak_counter", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "views", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_views_on_post_id"
    t.index ["user_id"], name: "index_views_on_user_id"
  end

  add_foreign_key "activity_streaks", "users"
  add_foreign_key "group_admins", "groups"
  add_foreign_key "group_admins", "users"
  add_foreign_key "join_requests", "groups"
  add_foreign_key "join_requests", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "notifications", "users", column: "creator_id"
  add_foreign_key "participants", "activities"
  add_foreign_key "participants", "users"
  add_foreign_key "professional_application_submissions", "users"
  add_foreign_key "professional_application_submissions", "users", column: "reviewer_id"
  add_foreign_key "professional_service_lengths", "professional_services"
  add_foreign_key "professional_services", "services"
  add_foreign_key "professional_services", "users"
  add_foreign_key "reports", "users"
  add_foreign_key "service_requests", "professional_service_lengths"
  add_foreign_key "service_requests", "users"
  add_foreign_key "service_requests", "users", column: "professional_id"
end
