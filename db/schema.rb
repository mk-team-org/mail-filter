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

ActiveRecord::Schema.define(version: 20171031152723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string   "email",                      null: false
    t.boolean  "excluded",   default: false, null: false
    t.boolean  "angry",      default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "search_queries", force: :cascade do |t|
    t.string   "first_name",                    null: false
    t.string   "last_name",                     null: false
    t.string   "domain",                        null: false
    t.string   "nip",                           null: false
    t.string   "company"
    t.text     "emails",        default: [],                 array: true
    t.boolean  "catch_all",     default: false
    t.boolean  "completed",     default: false
    t.string   "cant_check"
    t.text     "tested_emails", default: [],                 array: true
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "in_progress",   default: false
    t.index ["nip"], name: "index_search_queries_on_nip", using: :btree
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.boolean  "processed",   default: false, null: false
    t.string   "emails_file"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
