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

ActiveRecord::Schema.define(:version => 20110222101200) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["name"], :name => "index_clients_on_name", :unique => true

  create_table "group_projects", :force => true do |t|
    t.integer  "group_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_projects", ["group_id"], :name => "index_group_projects_on_group_id"
  add_index "group_projects", ["project_id"], :name => "index_group_projects_on_project_id"

  create_table "groups", :force => true do |t|
    t.integer  "nr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["nr"], :name => "index_groups_on_nr", :unique => true

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "client_id"
    t.text     "description", :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["client_id"], :name => "index_projects_on_client_id"
  add_index "projects", ["name"], :name => "index_projects_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["group_id"], :name => "index_users_on_group_id"

end
