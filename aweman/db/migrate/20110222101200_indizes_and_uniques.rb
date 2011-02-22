class IndizesAndUniques < ActiveRecord::Migration
  def self.up
    add_index :users, :group_id
    add_index :users, :email, :unique => true
    add_index :groups, :nr, :unique => true
    add_index :group_projects, :group_id
    add_index :group_projects, :project_id
    add_index :projects, :client_id
    add_index :projects, :name, :unique => true
    add_index :clients, :name, :unique => true
  end

  def self.down
    remove_index :users, :users_group_id_index
    remove_index :users, :users_email_index
    remove_index :groups, :groups_nr_index
    remove_index :group_projects, :groups_projects_group_id_index
    remove_index :group_projects, :groups_projects_project_id_index
    remove_index :projects, :projects_client_id_index
    remove_index :projects, :projects_name_index
    remove_index :clients, :clients_name_index
  end
end
