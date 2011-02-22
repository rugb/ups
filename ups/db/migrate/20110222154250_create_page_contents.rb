class CreatePageContents < ActiveRecord::Migration
  def self.up
    create_table :page_contents do |t|
      t.string :title
      t.text :text
      t.text :excerpt
      t.integer :page_id
      t.integer :language_id

      t.timestamps
    end
  end

  def self.down
    drop_table :page_contents
  end
end
