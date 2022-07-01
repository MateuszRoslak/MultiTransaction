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

ActiveRecord::Schema[7.0].define(version: 2022_06_15_121138) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "country", null: false
    t.string "city", null: false
    t.string "street", null: false
    t.string "building", null: false
    t.string "apartment"
    t.string "zip_code", null: false
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "card_code", null: false
    t.string "card_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "processor", null: false
    t.string "processor_id"
    t.boolean "default"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["processor", "processor_id"], name: "index_customers_on_processor_and_processor_id", unique: true
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_discount_id"
    t.index ["product_discount_id"], name: "index_line_items_on_product_discount_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
    t.index ["user_id", "product_id"], name: "index_line_items_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_line_items_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id"
    t.string "name", null: false
    t.string "currency", null: false
    t.integer "price", null: false
    t.integer "quantity", null: false
    t.integer "total", null: false
    t.integer "tax_total", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "number", null: false
    t.string "currency", null: false
    t.integer "item_quantity", null: false
    t.integer "items_total", null: false
    t.integer "items_total_net", null: false
    t.integer "tax_total", null: false
    t.integer "discount_total", null: false
    t.string "status", null: false
    t.string "session"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_orders_on_number", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_discounts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "card_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "discount_price", null: false
    t.integer "tax_value", null: false
    t.index ["product_id"], name: "index_product_discounts_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.integer "default_price", null: false
    t.string "currency", null: false
    t.text "description"
    t.integer "quantity", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tax_value", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "balance", default: 0, null: false
    t.string "currency", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "cards", "users"
  add_foreign_key "customers", "users"
  add_foreign_key "line_items", "product_discounts"
  add_foreign_key "line_items", "products"
  add_foreign_key "line_items", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "product_discounts", "products"
  add_foreign_key "wallets", "users"
end
