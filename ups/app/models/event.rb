# == Schema Information
# Schema version: 20110301093539
#
# Table name: events
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  user_id    :integer
#  location   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Event < ActiveRecord::Base
  attr_accessible :name, :user_id, :location

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :location, :presence => true, :length => { :maximum => 255 }
  validates :user_id, :presence => true

  
end
