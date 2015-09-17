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

ActiveRecord::Schema.define(version: 20150910051836) do

  create_table "addresses", force: :cascade do |t|
    t.string   "address_text", limit: 250,             null: false
    t.integer  "user_id",                  default: 0
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id"

  create_table "cart_items", force: :cascade do |t|
    t.integer  "user_id",         default: 0
    t.integer  "product_id",      default: 0
    t.integer  "asking_price",                null: false
    t.integer  "asking_quantity", default: 0, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "cart_items", ["user_id", "product_id"], name: "index_cart_items_on_user_id_and_product_id", unique: true

  create_table "order_items", force: :cascade do |t|
    t.integer  "user_id",    default: 0
    t.integer  "product_id", default: 0
    t.integer  "order_id",   default: 0
    t.integer  "price",                  null: false
    t.integer  "quantity",               null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "address_text", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title",          limit: 20,  null: false
    t.text     "description",    limit: 500, null: false
    t.string   "image_url",                  null: false
    t.integer  "price",                      null: false
    t.integer  "stock_quantity",             null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 50,  null: false
    t.string   "email",           limit: 256, null: false
    t.string   "password_digest",             null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
