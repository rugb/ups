class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :parent_id
      t.integer :position
      t.string :type
      t.datetime :start_time
      t.boolean :enabled
      t.string :forced_url

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
