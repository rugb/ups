class CreatePageTags < ActiveRecord::Migration
  def self.up
    create_table :page_tags do |t|
      t.integer :page_id
      t.integer :tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :page_tags
  end
end
