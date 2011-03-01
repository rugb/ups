class AddFlagsToFileUploads < ActiveRecord::Migration
  def self.up
    add_column :file_uploads, :visible, :boolean
  end

  def self.down
    remove_column :file_uploads, :visible
  end
end
