class CreateTimeslots < ActiveRecord::Migration
  def self.up
    create_table :timeslots do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :timeslots
  end
end
