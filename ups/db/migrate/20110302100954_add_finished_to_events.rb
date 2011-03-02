class AddFinishedToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :finished, :boolean
  end

  def self.down
    remove_column :events, :finished
  end
end
