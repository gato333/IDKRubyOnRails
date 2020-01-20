# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2017_05_02_183315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_results", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "imageurl"
    t.string "eventurl"
    t.float "lat"
    t.float "long"
    t.datetime "startdate"
    t.datetime "enddate"
    t.string "types"
    t.string "description"
    t.float "price"
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "creator_name"
    t.integer "creator_id"
    t.index ["creator_id", "created_at"], name: "index_event_results_on_creator_id_and_created_at"
    t.index ["name", "startdate"], name: "index_event_results_on_name_and_startdate", unique: true
  end

  create_table "user_events", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "event_id"], name: "index_user_events_on_user_id_and_event_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "user_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.string "description"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.boolean "reachable", default: true
    t.string "reset_digest"
    t.datetime "reset_sent_at"
  end

end
