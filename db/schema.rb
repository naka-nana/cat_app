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

ActiveRecord::Schema[7.0].define(version: 2024_03_11_065509) do
  create_table "cats", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "age_id", null: false
    t.date "birthday", null: false
    t.integer "breed_id", null: false
    t.integer "color_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cats_on_user_id"
  end

  create_table "posts", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "cat_id", null: false
    t.string "title", null: false
    t.text "text", null: false
    t.string "media_url", null: false
    t.string "media_type", null: false
    t.text "description"
    t.string "sharedWith", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cat_id"], name: "index_posts_on_cat_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.date "birth_date"
    t.integer "prefecture_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cats", "users"
  add_foreign_key "posts", "cats"
  add_foreign_key "posts", "users"
end
