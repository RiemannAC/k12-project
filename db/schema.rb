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

ActiveRecord::Schema.define(version: 20180911140916) do

  create_table "event_series", force: :cascade do |t|
    t.string "event_type", default: "subject"
    t.string "title", default: "未分類"
    t.string "grade", limit: 8, default: "", null: false
    t.string "class_name", limit: 8, default: "", null: false
    t.integer "students", default: 0
    t.string "color", default: "blue", null: false
    t.integer "frequency", default: 1
    t.string "period", default: "monthly"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean "all_day", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_event_series_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title", default: "未分類"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean "all_day", default: false
    t.text "description"
    t.string "image", default: "", null: false
    t.string "color", default: "green", null: false
    t.string "rate", default: "fair", null: false
    t.string "goal", default: "", null: false
    t.string "feedback_title", default: "", null: false
    t.text "feedback_comment", default: "", null: false
    t.integer "event_series_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_series_id"], name: "index_events_on_event_series_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "title", limit: 15
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "title", limit: 15
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachingfiles", force: :cascade do |t|
    t.string "filename"
    t.string "attachment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "material_id"
    t.integer "plan_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", limit: 32, default: "", null: false
    t.string "intro", limit: 140, default: ""
    t.string "title", limit: 32, default: ""
    t.string "role", default: "normal", null: false
    t.string "authentication_token"
    t.string "website", default: ""
    t.integer "share_class_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
