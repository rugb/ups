class AddCategoryIdToCategoryName < ActiveRecord::Migration
  def self.up
    add_column :category_names, :category_id, :integer
  end

  def self.down
    remove_column :category_names, :category_id
  end
end
