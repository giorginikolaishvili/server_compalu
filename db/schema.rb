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

ActiveRecord::Schema.define(version: 2019_06_27_174621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "profiles", force: :cascade do |t|
    t.string "name", limit: 50, null: false
  end

  create_table "user_portfolios", force: :cascade do |t|
    t.string "description"
    t.date "start_date"
    t.date "end_date"
    t.string "company_name"
    t.bigint "user_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.string "email", limit: 100, null: false
    t.date "birth_date"
    t.date "apply_date"
    t.date "graduate_date"
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "employed", default: false, null: false
    t.string "full_name", default: "", null: false
    t.string "image_base64"
    t.string "hobby"
    t.index ["profile_id"], name: "index_users_on_profile_id"
  end

  add_foreign_key "user_portfolios", "users"
  add_foreign_key "users", "profiles"
end
