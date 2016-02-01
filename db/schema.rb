# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160201064650) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_results", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "imageurl"
    t.string   "eventurl"
    t.float    "lat"
    t.float    "long"
    t.datetime "startdate"
    t.datetime "enddate"
    t.string   "types"
    t.string   "description"
    t.float    "price"
    t.string   "source"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "creator_name"
    t.integer  "creator_id"
  end

  create_table "user_events", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.integer  "user_type",         default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "picture"
    t.string   "description"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.boolean  "reachable",         default: true
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

end
