class AddGeventidToTimeslots < ActiveRecord::Migration
  def self.up
    add_column :timeslots, :gevent_id, :string
  end

  def self.down
    remove_column :timeslots, :gevent_id
  end
end
