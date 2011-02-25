class AddRoleIdToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :role_id, :integer
  end

  def self.down
    remove_column :pages, :role_id
  end
end
