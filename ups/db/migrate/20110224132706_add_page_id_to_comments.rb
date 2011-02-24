class AddPageIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :page_id, :integer
  end

  def self.down
    remove_column :comments, :page_id
  end
end
