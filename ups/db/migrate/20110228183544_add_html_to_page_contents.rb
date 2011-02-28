class AddHtmlToPageContents < ActiveRecord::Migration
  def self.up
    add_column :page_contents, :html, :text
  end

  def self.down
    remove_column :page_contents, :html
  end
end
