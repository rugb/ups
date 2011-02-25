class DelOpenIdNonces < ActiveRecord::Migration
  def self.up
    drop_table :open_id_nonces
  end

  def self.down
    create_table "open_id_nonces", :force => true do |t|
      t.string  "server_url", :null => false
      t.integer "timestamp",  :null => false
      t.string  "salt",       :null => false
    end
  end
end
