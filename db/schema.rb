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

ActiveRecord::Schema.define(version: 20151215063700) do

  create_table "clearcart_options", force: :cascade do |t|
    t.text     "opt_in_message"
    t.text     "opt_in_refusal_message"
    t.text     "welcome_message"
    t.text     "initial_cart_abandonment_message"
    t.text     "follow_up_message"
    t.text     "cancellation_message"
    t.text     "confirmation_message"
    t.integer  "number_of_times_to_message"
    t.integer  "time_interval_between_messages"
    t.datetime "deleted_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "opt_in_verification_url"
    t.string   "opt_in_confirmation_url"
    t.string   "purchase_request_url"
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deleted_at"
  end

  add_index "customers", ["deleted_at"], name: "index_customers_on_deleted_at"

  create_table "keyword_options", force: :cascade do |t|
    t.text     "opt_in_message"
    t.text     "opt_in_refusal_message"
    t.text     "welcome_message"
    t.text     "transactional_message"
    t.text     "cancellation_message"
    t.text     "confirmation_message"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.datetime "deleted_at"
    t.string   "opt_in_verification_url"
    t.string   "opt_in_confirmation_url"
    t.string   "purchase_request_url"
  end

  add_index "keyword_options", ["deleted_at"], name: "index_keyword_options_on_deleted_at"

  create_table "opt_ins", force: :cascade do |t|
    t.integer  "subscription_id"
    t.integer  "customer_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "completed",         default: false
    t.datetime "deleted_at"
    t.string   "verification_code"
  end

  add_index "opt_ins", ["deleted_at"], name: "index_opt_ins_on_deleted_at"

  create_table "organizations", force: :cascade do |t|
    t.string   "organization_name"
    t.string   "email"
    t.string   "auth_token"
    t.string   "phone"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "deleted_at"
  end

  add_index "organizations", ["deleted_at"], name: "index_organizations_on_deleted_at"

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.boolean  "has_items",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.datetime "deleted_at"
  end

  add_index "products", ["deleted_at"], name: "index_products_on_deleted_at"

  create_table "safetext_options", force: :cascade do |t|
    t.text     "opt_in_message"
    t.text     "opt_in_refusal_message"
    t.text     "welcome_message"
    t.text     "transactional_message"
    t.text     "cancellation_message"
    t.text     "confirmation_message"
    t.datetime "deleted_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "opt_in_verification_url"
    t.string   "opt_in_confirmation_url"
    t.string   "purchase_request_url"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "product_id"
    t.integer  "short_code"
    t.string   "options_id"
    t.string   "options_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deleted_at"
  end

  add_index "subscriptions", ["deleted_at"], name: "index_subscriptions_on_deleted_at"

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "deleted_at"
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.boolean  "is_primary",             default: false
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true

end
