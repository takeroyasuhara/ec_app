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
    t.string   "address_text", limit: 250, default: "no text", null: false
    t.integer  "user_id",      limit: 4,   default: 0,         null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "cart_items", force: :cascade do |t|
    t.integer  "user_id",          limit: 4,   default: 0,   null: false
    t.integer  "product_id",       limit: 4,   default: 0,   null: false
    t.integer  "price_in_cart",    limit: 4,   default: 0,   null: false
    t.integer  "quantity_in_cart", limit: 4,   default: 0,   null: false
    t.string   "lock_token",       limit: 255, default: "0", null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "cart_items", ["user_id", "product_id"], name: "index_cart_items_on_user_id_and_product_id", unique: true, using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, default: 0, null: false
    t.integer  "product_id", limit: 4, default: 0, null: false
    t.integer  "order_id",   limit: 4, default: 0, null: false
    t.integer  "price",      limit: 4, default: 0, null: false
    t.integer  "quantity",   limit: 4, default: 0, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "address_text", limit: 250, default: "no text", null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title",          limit: 20,    default: "no title", null: false
    t.text     "description",    limit: 65535,                      null: false
    t.string   "image_url",      limit: 255,   default: "no url",   null: false
    t.integer  "price",          limit: 4,     default: 0,          null: false
    t.integer  "stock_quantity", limit: 4,     default: 0,          null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 50,  default: "no name",  null: false
    t.string   "email",           limit: 255, default: "no email", null: false
    t.string   "password_digest", limit: 255,                      null: false
    t.string   "remember_digest", limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
