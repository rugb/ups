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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110301162300) do

  create_table "categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_names", :force => true do |t|
    t.string   "name"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email"
    t.integer  "page_id"
  end

  create_table "confs", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "end_at"
    t.text     "description"
  end

  create_table "file_uploads", :force => true do |t|
    t.integer  "page_id"
    t.string   "filename"
    t.string   "file"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "size"
    t.boolean  "visible"
  end

  create_table "languages", :force => true do |t|
    t.string   "short"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["short"], :name => "index_languages_on_short"

  create_table "link_categories", :force => true do |t|
    t.integer  "link_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "title"
    t.string   "href"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_categories", :force => true do |t|
    t.integer  "page_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_contents", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.text     "excerpt"
    t.integer  "page_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "html"
  end

  create_table "page_tags", :force => true do |t|
    t.integer  "page_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "position"
    t.string   "page_type"
    t.datetime "start_at"
    t.boolean  "enabled"
    t.string   "forced_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "int_title"
    t.integer  "user_id"
    t.integer  "role_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "int_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timeslots", :force => true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_votes", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "openid"
    t.string   "email"
    t.string   "name"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fullname"
    t.string   "salt"
    t.integer  "language_id"
  end

  add_index "users", ["salt"], :name => "index_users_on_salt", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_vote_id"
    t.boolean  "ack"
    t.integer  "timeslot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
