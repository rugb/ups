class AddEnableCommentsToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :enable_comments, :boolean
  end

  def self.down
    remove_column :pages, :enable_comments
  end
end
