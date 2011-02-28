class AddSizeToFileUploads < ActiveRecord::Migration
  def self.up
    add_column :file_uploads, :size, :integer
  end

  def self.down
    remove_column :file_uploads, :size
  end
end
