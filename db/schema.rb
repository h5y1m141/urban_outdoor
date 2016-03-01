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

ActiveRecord::Schema.define(version: 20160301080847) do

  create_table "article_elements", force: :cascade do |t|
    t.string   "tag_name",     limit: 255
    t.text     "element_data", limit: 65535
    t.integer  "article_id",   limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "article_elements", ["article_id"], name: "index_article_elements_on_article_id", using: :btree

  create_table "article_item_relays", force: :cascade do |t|
    t.integer  "item_id",    limit: 4
    t.integer  "article_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "article_picture_relays", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.integer  "picture_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.integer  "publish_status", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "preview_key",    limit: 255
  end

  add_index "articles", ["preview_key"], name: "index_articles_on_preview_key", using: :btree

  create_table "brands", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "furigana",   limit: 255
    t.string   "url",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "item_favorites", force: :cascade do |t|
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.text     "comment",       limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "item_reviews", force: :cascade do |t|
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.text     "comment",       limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name",           limit: 255,   null: false
    t.string   "url",            limit: 255,   null: false
    t.integer  "original_price", limit: 4
    t.boolean  "discounted",     limit: 1
    t.integer  "discount_price", limit: 4
    t.text     "description",    limit: 65535
    t.string   "image",          limit: 255
    t.integer  "store_id",       limit: 4,     null: false
    t.integer  "brand_id",       limit: 4,     null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "thumbnail_id",   limit: 4
  end

  add_index "items", ["name"], name: "index_items_on_name", using: :btree
  add_index "items", ["thumbnail_id"], name: "index_items_on_thumbnail_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.integer  "width",                limit: 4
    t.integer  "height",               limit: 4
    t.string   "image",                limit: 255
    t.string   "original_picture_url", limit: 255
    t.integer  "item_id",              limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "pictures", ["item_id"], name: "index_pictures_on_item_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "url",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.integer  "item_id",    limit: 4
    t.string   "color",      limit: 255
    t.string   "size",       limit: 255
    t.boolean  "in_stock",   limit: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "stocks", ["item_id"], name: "index_stocks_on_item_id", using: :btree

  create_table "stores", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "furigana",   limit: 255
    t.string   "url",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "item_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tags", ["item_id"], name: "index_tags_on_item_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "article_elements", "articles"
  add_foreign_key "pictures", "items"
  add_foreign_key "stocks", "items"
  add_foreign_key "tags", "items"
end
