class CreateLinkCategories < ActiveRecord::Migration
  def self.up
    create_table :link_categories do |t|
      t.integer :link_id
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :link_categories
  end
end
