class AddEditRoleIdToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :edit_role_id, :integer
  end

  def self.down
    remove_column :pages, :edit_role_id
  end
end
