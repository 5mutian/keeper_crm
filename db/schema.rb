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

ActiveRecord::Schema.define(version: 20170519015715) do

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

  create_table "clues", force: :cascade do |t|
    t.string   "name"
    t.string   "mobile",      null: false
    t.string   "address"
    t.text     "remark"
    t.integer  "user_id",     null: false
    t.integer  "account_id",  null: false
    t.integer  "customer_id", null: false
    t.integer  "clues_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "tel",        null: false
    t.string   "province"
    t.string   "city"
    t.string   "area"
    t.string   "street"
    t.string   "address"
    t.string   "longitude"
    t.string   "latitude"
    t.string   "remark"
    t.integer  "user_id",    null: false
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "uuid"
    t.integer  "width"
    t.integer  "height"
    t.float    "expected_square",                default: 0.0
    t.datetime "booking_date",                                   null: false
    t.float    "rate"
    t.float    "total"
    t.string   "remark"
    t.string   "state"
    t.string   "courier_number"
    t.datetime "install_date"
    t.integer  "cgj_company_id"
    t.integer  "cgj_customer_id"
    t.integer  "cgj_facilitator_id"
    t.integer  "cgj_customer_service_id"
    t.string   "material"
    t.integer  "material_id"
    t.string   "workflow_state"
    t.boolean  "public_order"
    t.float    "square"
    t.boolean  "mount_order"
    t.string   "serial_number"
    t.boolean  "is_company"
    t.float    "measure_amount"
    t.float    "install_amount"
    t.boolean  "manager_confirm"
    t.string   "region",                         default: "CRM"
    t.float    "terminal_count"
    t.float    "amount_total_count"
    t.integer  "basic_order_tax"
    t.integer  "measure_amount_after_comment"
    t.integer  "installed_amount_after_comment"
    t.integer  "measure_comment"
    t.float    "measure_raty"
    t.float    "installed_raty"
    t.float    "service_measure_amount"
    t.float    "service_installed_amount"
    t.float    "basic_tax"
    t.float    "deduct_installed_cost"
    t.float    "deduct_measure_cost"
    t.integer  "sale_commission"
    t.integer  "intro_commission"
    t.integer  "user_id",                                        null: false
    t.integer  "account_id",                                     null: false
    t.integer  "customer_id",                                    null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "name",               null: false
    t.string   "_controller_action", null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "permissions_users", id: false, force: :cascade do |t|
    t.integer "permission_id"
    t.integer "user_id"
  end

  add_index "permissions_users", ["permission_id", "user_id"], name: "index_permissions_users_on_permission_id_and_user_id", using: :btree
  add_index "permissions_users", ["user_id", "permission_id"], name: "index_permissions_users_on_user_id_and_permission_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "code",       null: false
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name",                     null: false
    t.string   "code",                     null: false
    t.string   "contact"
    t.string   "phone"
    t.string   "address"
    t.text     "product_ids", default: [],              array: true
    t.integer  "account_id",               null: false
    t.integer  "region_id",                null: false
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
    t.string   "mobile",                        null: false
    t.string   "password_digest"
    t.string   "remeber_digest"
    t.string   "name",                          null: false
    t.string   "role",                          null: false
    t.integer  "status",            default: 1
    t.string   "open_id"
    t.integer  "cgj_user_id"
    t.integer  "account_id",                    null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "saler_director_id"
  end

end
