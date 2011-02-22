class AddIntTitleToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :int_title, :string
  end

  def self.down
    remove_column :pages, :int_title
  end
end
