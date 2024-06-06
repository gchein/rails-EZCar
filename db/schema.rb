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

ActiveRecord::Schema[7.1].define(version: 2024_06_05_175202) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.bigint "renter_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "total_cost"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_bookings_on_car_id"
    t.index ["renter_id"], name: "index_bookings_on_renter_id"
  end

  create_table "cars", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "brand"
    t.string "model"
    t.integer "year"
    t.string "category"
    t.integer "mileage"
    t.string "color"
    t.string "license_plate"
    t.text "description"
    t.boolean "availability", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "daily_price"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.index ["owner_id"], name: "index_cars_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "cars"
  add_foreign_key "bookings", "users", column: "renter_id"
  add_foreign_key "cars", "users", column: "owner_id"
end
