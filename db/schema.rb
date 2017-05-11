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

ActiveRecord::Schema.define(version: 20170511052039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "code",        null: false
    t.string   "type",        null: false
    t.string   "reg_address"
    t.string   "address"
    t.integer  "company_ids",              array: true
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "channels", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "code",       null: false
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clues", force: :cascade do |t|
    t.string   "name"
    t.string   "mobile",     null: false
    t.string   "address"
    t.text     "remark"
    t.integer  "user_id",    null: false
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "code",        null: false
    t.string   "description"
    t.string   "color"
    t.integer  "account_id",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name",                     null: false
    t.string   "code",                     null: false
    t.string   "contact"
    t.string   "phone"
    t.string   "address"
    t.text     "product_ids", default: [],              array: true
    t.integer  "account_id",               null: false
    t.integer  "channel_id",               null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "t_value"
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "mobile",                      null: false
    t.string   "password_digest"
    t.string   "remeber_digest"
    t.string   "name",                        null: false
    t.string   "role",                        null: false
    t.integer  "status",          default: 1
    t.string   "open_id"
    t.integer  "account_id",                  null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

end
