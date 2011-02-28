class CreateFileUploads < ActiveRecord::Migration
  def self.up
    create_table :file_uploads do |t|
      t.integer :page_id
      t.string :filename
      t.string :file
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :file_uploads
  end
end
