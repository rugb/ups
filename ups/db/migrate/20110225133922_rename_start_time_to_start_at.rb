class RenameStartTimeToStartAt < ActiveRecord::Migration
  def self.up
    rename_column :pages, :start_time, :start_at
  end

  def self.down
    rename_column :pages, :start_at, :start_time
  end
end
