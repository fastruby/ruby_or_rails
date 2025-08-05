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

ActiveRecord::Schema[8.0].define(version: 2025_06_02_180541) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "puzzle_id", null: false
    t.bigint "user_id", null: false
    t.integer "choice"
    t.boolean "is_correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.bigint "server_id", null: false
    t.index ["puzzle_id"], name: "index_answers_on_puzzle_id"
    t.index ["server_id"], name: "index_answers_on_server_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "channels", force: :cascade do |t|
    t.bigint "server_id", null: false
    t.string "channel_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id"], name: "index_channels_on_server_id"
  end

  create_table "puzzles", force: :cascade do |t|
    t.string "question", null: false
    t.integer "answer", null: false
    t.text "explanation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sent_at"
    t.string "link"
    t.integer "state", default: 2, null: false
    t.string "suggested_by"
  end

  create_table "servers", force: :cascade do |t|
    t.string "server_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["server_id"], name: "index_servers_on_server_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "username", null: false
    t.integer "role", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

  create_table "users_servers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "server_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id"], name: "index_users_servers_on_server_id"
    t.index ["user_id", "server_id"], name: "index_users_servers_on_user_id_and_server_id", unique: true
    t.index ["user_id"], name: "index_users_servers_on_user_id"
  end

  add_foreign_key "answers", "puzzles"
  add_foreign_key "answers", "servers"
  add_foreign_key "answers", "users"
  add_foreign_key "channels", "servers"
  add_foreign_key "users_servers", "servers"
  add_foreign_key "users_servers", "users"
end
