class CreateCategoryNames < ActiveRecord::Migration
  def self.up
    create_table :category_names do |t|
      t.string :name
      t.integer :language_id

      t.timestamps
    end
  end

  def self.down
    drop_table :category_names
  end
end
