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

ActiveRecord::Schema.define(version: 2022_09_16_175123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "super_heros", force: :cascade do |t|
    t.string "name"
    t.string "superpower"
    t.bigint "god_object_id"
    t.bigint "vehicle_id"
    t.bigint "fruit_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fruit_id"], name: "index_super_heros_on_fruit_id"
    t.index ["god_object_id"], name: "index_super_heros_on_god_object_id"
    t.index ["vehicle_id"], name: "index_super_heros_on_vehicle_id"
  end

end
