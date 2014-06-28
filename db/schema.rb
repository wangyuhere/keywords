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

ActiveRecord::Schema.define(version: 20140628195708) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "url"
    t.integer  "source_id",    null: false
    t.datetime "published_at", null: false
    t.datetime "indexed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["indexed_at"], name: "index_articles_on_indexed_at", using: :btree
  add_index "articles", ["published_at"], name: "index_articles_on_published_at", using: :btree
  add_index "articles", ["source_id"], name: "index_articles_on_source_id", using: :btree
  add_index "articles", ["url"], name: "index_articles_on_url", unique: true, using: :btree

  create_table "occurrences", force: true do |t|
    t.integer "word_id",    null: false
    t.integer "article_id", null: false
    t.integer "source_id",  null: false
  end

  add_index "occurrences", ["article_id"], name: "index_occurrences_on_article_id", using: :btree
  add_index "occurrences", ["source_id"], name: "index_occurrences_on_source_id", using: :btree
  add_index "occurrences", ["word_id"], name: "index_occurrences_on_word_id", using: :btree

  create_table "sources", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "feed_url"
    t.datetime "last_modified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "css_selector"
  end

  add_index "sources", ["last_modified_at"], name: "index_sources_on_last_modified_at", using: :btree

  create_table "words", force: true do |t|
    t.string   "name",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "occurrences_count", default: 0
    t.integer  "articles_count",    default: 0
  end

  add_index "words", ["articles_count"], name: "index_words_on_articles_count", using: :btree
  add_index "words", ["name"], name: "index_words_on_name", unique: true, using: :btree
  add_index "words", ["occurrences_count"], name: "index_words_on_occurrences_count", using: :btree

end
