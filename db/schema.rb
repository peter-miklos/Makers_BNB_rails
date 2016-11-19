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

ActiveRecord::Schema.define(version: 20161119225948) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "space_id"
    t.integer  "request_id"
    t.index ["request_id"], name: "index_bookings_on_request_id", using: :btree
    t.index ["space_id"], name: "index_bookings_on_space_id", using: :btree
  end

  create_table "request_dates", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "request_id"
    t.index ["request_id"], name: "index_request_dates_on_request_id", using: :btree
  end

  create_table "requests", force: :cascade do |t|
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "space_id"
    t.index ["space_id"], name: "index_requests_on_space_id", using: :btree
  end

  create_table "space_dates", force: :cascade do |t|
    t.date     "date"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "space_id"
    t.index ["space_id"], name: "index_space_dates_on_space_id", using: :btree
  end

  create_table "spaces", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.float    "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "bookings", "requests"
  add_foreign_key "bookings", "spaces"
  add_foreign_key "request_dates", "requests"
  add_foreign_key "requests", "spaces"
  add_foreign_key "space_dates", "spaces"
end
