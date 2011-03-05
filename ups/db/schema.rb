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

ActiveRecord::Schema.define(:version => 20110303160424) do

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

  add_index "category_names", ["category_id"], :name => "index_category_names_on_category_id"
  add_index "category_names", ["language_id"], :name => "index_category_names_on_language_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email"
    t.integer  "page_id"
  end

  add_index "comments", ["page_id"], :name => "index_comments_on_page_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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
    t.boolean  "finished"
  end

  add_index "events", ["user_id"], :name => "index_events_on_user_id"

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

  add_index "file_uploads", ["filename"], :name => "index_file_uploads_on_filename"
  add_index "file_uploads", ["page_id"], :name => "index_file_uploads_on_page_id"

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

  add_index "link_categories", ["category_id"], :name => "index_link_categories_on_category_id"
  add_index "link_categories", ["link_id"], :name => "index_link_categories_on_link_id"

  create_table "links", :force => true do |t|
    t.string   "title"
    t.string   "href"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_categories", :force => true do |t|
    t.integer  "page_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_categories", ["category_id"], :name => "index_page_categories_on_category_id"
  add_index "page_categories", ["page_id"], :name => "index_page_categories_on_page_id"

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

  add_index "page_contents", ["language_id"], :name => "index_page_contents_on_language_id"
  add_index "page_contents", ["page_id"], :name => "index_page_contents_on_page_id"

  create_table "page_tags", :force => true do |t|
    t.integer  "page_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_tags", ["page_id"], :name => "index_page_tags_on_page_id"
  add_index "page_tags", ["tag_id"], :name => "index_page_tags_on_tag_id"

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
    t.integer  "edit_role_id"
    t.boolean  "enable_comments"
  end

  add_index "pages", ["edit_role_id"], :name => "index_pages_on_edit_role_id"
  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
  add_index "pages", ["position"], :name => "index_pages_on_position"
  add_index "pages", ["role_id"], :name => "index_pages_on_role_id"
  add_index "pages", ["user_id"], :name => "index_pages_on_user_id"
  add_index "pages", ["page_type"], :name => "index_pages_on_page_type"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "int_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["int_name"], :name => "index_roles_on_int_name"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "timeslots", :force => true do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gevent_id"
  end

  add_index "timeslots", ["event_id"], :name => "index_timeslots_on_event_id"
  add_index "timeslots", ["gevent_id"], :name => "index_timeslots_on_gevent_id"

  create_table "user_votes", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_votes", ["event_id"], :name => "index_user_votes_on_event_id"
  add_index "user_votes", ["user_id"], :name => "index_user_votes_on_user_id"

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

  add_index "users", ["role_id"], :name => "index_users_on_role_id"
  add_index "users", ["language_id"], :name => "index_users_on_language_id"
  add_index "users", ["salt"], :name => "index_users_on_salt", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_vote_id"
    t.boolean  "ack"
    t.integer  "timeslot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["timeslot_id"], :name => "index_votes_on_timeslot_id"
  add_index "votes", ["user_vote_id"], :name => "index_votes_on_user_vote_id"

end
