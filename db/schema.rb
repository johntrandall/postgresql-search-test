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

ActiveRecord::Schema.define(version: 2022_09_16_152315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fruits", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "color"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "god_object_id"
    t.index ["god_object_id"], name: "index_fruits_on_god_object_id"
  end

  create_table "god_objects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "god_object_id"
    t.bigint "fruit_id"
    t.index ["fruit_id"], name: "index_pg_search_documents_on_fruit_id"
    t.index ["god_object_id"], name: "index_pg_search_documents_on_god_object_id"
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "wheel_description"
    t.bigint "fruit_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "god_object_id"
    t.index ["fruit_id"], name: "index_vehicles_on_fruit_id"
    t.index ["god_object_id"], name: "index_vehicles_on_god_object_id"
  end

end
