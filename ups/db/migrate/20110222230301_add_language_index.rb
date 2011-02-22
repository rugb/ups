class AddLanguageIndex < ActiveRecord::Migration
  def self.up
    add_index :languages, :short
  end

  def self.down
    remove_index :languages, :short
  end
end
