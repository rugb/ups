class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :openid
      t.string :email
      t.string :name
      t.integer :role

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
