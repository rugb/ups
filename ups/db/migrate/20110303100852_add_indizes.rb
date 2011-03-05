class AddIndizes < ActiveRecord::Migration
  def self.up
    add_index :page_categories, :page_id
    add_index :page_categories, :category_id

    add_index :page_contents, :page_id
    add_index :page_contents, :language_id

    add_index :page_tags, :page_id
    add_index :page_tags, :tag_id

    add_index :pages, :parent_id
    add_index :pages, :position
    add_index :pages, :role_id
    add_index :pages, :edit_role_id
    add_index :pages, :user_id
    add_index :pages, :page_type

    add_index :roles, :int_name

    add_index :tags, :name

    add_index :timeslots, :event_id

    add_index :user_votes, :event_id
    add_index :user_votes, :user_id

    add_index :users, :role_id

    add_index :votes, :user_vote_id
    add_index :votes, :timeslot_id

    add_index :category_names, :language_id
    add_index :category_names, :category_id

    add_index :comments, :user_id
    add_index :comments, :page_id

    add_index :events, :user_id

    add_index :file_uploads, :page_id
    add_index :file_uploads, :filename

    add_index :link_categories, :link_id
    add_index :link_categories, :category_id

    add_index :timeslots, :gevent_id

    add_index :users, :language_id

    remove_column :links, :category_id
  end

  def self.down
    remove_index :page_categories, :page_id
    remove_index :page_categories, :category_id

    remove_index :page_contents, :page_id
    remove_index :page_contents, :language_id

    remove_index :page_tags, :page_id
    remove_index :page_tags, :tag_id

    remove_index :pages, :parent_id
    remove_index :pages, :position
    remove_index :pages, :role_id
    remove_index :pages, :edit_role_id
    remove_index :pages, :user_id
    remove_index :pages, :page_type

    remove_index :roles, :int_name

    remove_index :tags, :name

    remove_index :timeslots, :event_id

    remove_index :user_votes, :event_id
    remove_index :user_votes, :user_id

    remove_index :users, :role_id

    remove_index :votes, :user_vode_id
    remove_index :votes, :timeslot_id

    remove_index :category_names, :language_id
    remove_index :category_names, :category_id

    remove_index :comments, :user_id
    remove_index :comments, :page_id

    remove_index :events, :user_id

    remove_index :file_uploads, :page_id
    remove_index :file_uploads, :filename

    remove_index :link_categories, :link_id
    remove_index :link_categories, :category_id

    remove_index :timeslots, :gevent_id

    remove_index :users, :language_id

    add_column :links, :category_id, :integer
  end
end
