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

ActiveRecord::Schema[7.0].define(version: 2022_05_26_212737) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jewels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jewels_projects", id: false, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "jewel_id", null: false
    t.index ["jewel_id", "project_id"], name: "index_jewels_projects_on_jewel_id_and_project_id", unique: true
    t.index ["project_id", "jewel_id"], name: "index_jewels_projects_on_project_id_and_jewel_id", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.integer "stars_count"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
