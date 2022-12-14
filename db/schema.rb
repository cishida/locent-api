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

ActiveRecord::Schema.define(version: 20160211090359) do

  create_table "campaigns", force: :cascade do |t|
    t.string   "kind"
    t.integer  "number_of_targets"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name"
    t.datetime "deleted_at"
    t.integer  "organization_id"
    t.text     "message"
  end

  add_index "campaigns", ["deleted_at"], name: "index_campaigns_on_deleted_at"
  add_index "campaigns", ["organization_id"], name: "index_campaigns_on_organization_id"

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
    t.text     "invalid_message_response"
    t.text     "opt_in_invalid_message_response"
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deleted_at"
    t.string   "uid"
  end

  add_index "customers", ["deleted_at"], name: "index_customers_on_deleted_at"
  add_index "customers", ["organization_id"], name: "index_customers_on_organization_id"

  create_table "error_messages", force: :cascade do |t|
    t.integer  "error_id"
    t.text     "message"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deleted_at"
  end

  add_index "error_messages", ["deleted_at"], name: "index_error_messages_on_deleted_at"
  add_index "error_messages", ["error_id"], name: "index_error_messages_on_error_id"
  add_index "error_messages", ["organization_id"], name: "index_error_messages_on_organization_id"

  create_table "errors", force: :cascade do |t|
    t.integer  "code"
    t.string   "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deleted_at"
    t.text     "default_message"
  end

  add_index "errors", ["deleted_at"], name: "index_errors_on_deleted_at"

  create_table "features", force: :cascade do |t|
    t.string   "name"
    t.boolean  "has_products", default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "deleted_at"
  end

  add_index "features", ["deleted_at"], name: "index_features_on_deleted_at"

  create_table "keyword_options", force: :cascade do |t|
    t.text     "opt_in_message"
    t.text     "opt_in_refusal_message"
    t.text     "welcome_message"
    t.text     "transactional_message"
    t.text     "cancellation_message"
    t.text     "confirmation_message"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.datetime "deleted_at"
    t.string   "opt_in_verification_url"
    t.string   "opt_in_confirmation_url"
    t.string   "purchase_request_url"
    t.text     "opt_in_invalid_message_response"
  end

  add_index "keyword_options", ["deleted_at"], name: "index_keyword_options_on_deleted_at"

  create_table "keyword_products", force: :cascade do |t|
    t.string   "product_name"
    t.string   "product_uid"
    t.integer  "subscription_id"
    t.string   "keyword"
    t.decimal  "price"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "sid"
    t.string   "status"
    t.string   "to"
    t.string   "body"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "kind"
    t.string   "from"
    t.integer  "purpose_id"
    t.string   "purpose_type"
    t.datetime "deleted_at"
    t.integer  "organization_id"
  end

  add_index "messages", ["deleted_at"], name: "index_messages_on_deleted_at"
  add_index "messages", ["purpose_id", "purpose_type"], name: "index_messages_on_purpose_id_and_purpose_type"

  create_table "opt_ins", force: :cascade do |t|
    t.integer  "subscription_id"
    t.integer  "customer_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "completed",         default: false
    t.datetime "deleted_at"
    t.string   "verification_code"
    t.integer  "feature_id"
    t.boolean  "active",            default: true
  end

  add_index "opt_ins", ["customer_id"], name: "index_opt_ins_on_customer_id"
  add_index "opt_ins", ["deleted_at"], name: "index_opt_ins_on_deleted_at"
  add_index "opt_ins", ["feature_id"], name: "index_opt_ins_on_feature_id"
  add_index "opt_ins", ["subscription_id"], name: "index_opt_ins_on_subscription_id"

  create_table "orders", force: :cascade do |t|
    t.string   "uid"
    t.string   "description"
    t.decimal  "price"
    t.integer  "opt_in_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "completed",           default: false
    t.boolean  "confirmed"
    t.boolean  "order_success"
    t.string   "feature"
    t.integer  "organization_id"
    t.string   "status"
    t.integer  "percentage_discount"
  end

  add_index "orders", ["deleted_at"], name: "index_orders_on_deleted_at"
  add_index "orders", ["opt_in_id"], name: "index_orders_on_opt_in_id"
  add_index "orders", ["organization_id"], name: "index_orders_on_organization_id"

  create_table "organizations", force: :cascade do |t|
    t.string   "organization_name"
    t.string   "email"
    t.string   "auth_token"
    t.string   "phone"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "deleted_at"
    t.string   "short_code"
    t.string   "long_number"
    t.text     "customer_invalid_message_response"
    t.text     "stranger_invalid_message_response"
  end

  add_index "organizations", ["deleted_at"], name: "index_organizations_on_deleted_at"

  create_table "products", force: :cascade do |t|
    t.string   "uid",             null: false
    t.string   "name"
    t.integer  "subscription_id"
    t.string   "keyword"
    t.decimal  "price"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organization_id"
    t.datetime "deleted_at"
  end

  add_index "products", ["deleted_at"], name: "index_products_on_deleted_at"
  add_index "products", ["organization_id"], name: "index_products_on_organization_id"
  add_index "products", ["subscription_id"], name: "index_products_on_subscription_id"

  create_table "reminders", force: :cascade do |t|
    t.integer  "number_of_times"
    t.integer  "order_id"
    t.integer  "interval"
    t.boolean  "active",          default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "deleted_at"
    t.datetime "last_sent"
  end

  add_index "reminders", ["deleted_at"], name: "index_reminders_on_deleted_at"
  add_index "reminders", ["order_id"], name: "index_reminders_on_order_id"

  create_table "safetext_options", force: :cascade do |t|
    t.text     "opt_in_message"
    t.text     "opt_in_refusal_message"
    t.text     "welcome_message"
    t.text     "transactional_message"
    t.text     "cancellation_message"
    t.text     "confirmation_message"
    t.datetime "deleted_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "opt_in_verification_url"
    t.string   "opt_in_confirmation_url"
    t.string   "purchase_request_url"
    t.text     "invalid_message_response"
    t.text     "opt_in_invalid_message_response"
  end

  create_table "shortcode_applications", force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "vanity_or_random"
    t.string   "payment_frequency"
    t.string   "company_name"
    t.text     "company_mailing_address"
    t.string   "city"
    t.string   "state_or_province"
    t.string   "primary_contact_name"
    t.string   "primary_contact_number"
    t.string   "support_email_address"
    t.string   "support_toll_free_number"
    t.string   "company_tax_id"
    t.string   "company_email"
    t.string   "help_message"
    t.string   "stop_message"
    t.integer  "organization_id"
    t.string   "status"
  end

  add_index "shortcode_applications", ["organization_id"], name: "index_shortcode_applications_on_organization_id"

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "organization_id"
    t.integer  "feature_id"
    t.string   "options_id"
    t.string   "options_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.datetime "deleted_at"
  end

  add_index "subscriptions", ["deleted_at"], name: "index_subscriptions_on_deleted_at"
  add_index "subscriptions", ["feature_id"], name: "index_subscriptions_on_feature_id"
  add_index "subscriptions", ["options_id", "options_type"], name: "index_subscriptions_on_options_id_and_options_type"
  add_index "subscriptions", ["organization_id"], name: "index_subscriptions_on_organization_id"

  create_table "super_admins", force: :cascade do |t|
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
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "super_admins", ["email"], name: "index_super_admins_on_email"
  add_index "super_admins", ["reset_password_token"], name: "index_super_admins_on_reset_password_token", unique: true
  add_index "super_admins", ["uid", "provider"], name: "index_super_admins_on_uid_and_provider", unique: true

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
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["organization_id"], name: "index_users_on_organization_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true

end
