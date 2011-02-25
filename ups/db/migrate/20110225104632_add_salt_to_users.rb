class AddSaltToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :salt, :string
    
    add_index :users, :salt, :unique => true
  end

  def self.down
    remove_column :users, :salt
    
    remove_index :users, :salt
  end
end
