class DeleteDateFromComments < ActiveRecord::Migration
  def self.up
    remove_column :comments, :date
  end

  def self.down
    add_column :comments, :date
  end
end
