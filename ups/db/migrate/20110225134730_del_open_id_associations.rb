class DelOpenIdAssociations < ActiveRecord::Migration
  def self.up
    drop_table :open_id_associations
  end

  def self.down
    create_table "open_id_associations", :force => true do |t|
      t.binary  "server_url", :null => false
      t.string  "handle",     :null => false
      t.binary  "secret",     :null => false
      t.integer "issued",     :null => false
      t.integer "lifetime",   :null => false
      t.string  "assoc_type", :null => false
    end
  end
end
