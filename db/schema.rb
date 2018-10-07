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

ActiveRecord::Schema.define(version: 20181007083554) do

  create_table "aims", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "topic_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "subject_id"
    t.string "event_type", default: "lesson"
    t.string "classroom"
  end

  create_table "materials", force: :cascade do |t|
    t.string "mtrial_folder_name"
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "subject_tag_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "plan_folder_name"
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "subject_tag_id"
    t.integer "user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "start_week"
    t.datetime "end_week"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subject_tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "未分類"
    t.string "grade", default: ""
    t.string "classroom", default: ""
    t.integer "students", default: 0
    t.string "event_type", default: "lesson", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "color", default: "blue"
    t.integer "frequency", default: 1
    t.string "period", default: "weekly"
    t.boolean "all_day", default: false
    t.integer "user_id"
  end

  create_table "teachingfiles", force: :cascade do |t|
    t.string "name"
    t.string "attachments"
    t.integer "material_id"
    t.integer "plan_id"
    t.integer "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.datetime "set_week"
    t.string "file_upload"
    t.text "feedback"
    t.integer "subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "start_time"
    t.string "end_time"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", limit: 32, default: "", null: false
    t.text "intro"
    t.string "avatar"
    t.string "job_title", limit: 32, default: ""
    t.string "role", default: "normal", null: false
    t.string "website", default: ""
    t.string "authentication_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "share_class_count", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
