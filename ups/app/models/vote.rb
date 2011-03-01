# == Schema Information
# Schema version: 20110301093539
#
# Table name: votes
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  ack         :boolean
#  timeslot_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Vote < ActiveRecord::Base
  attr_accessible :ack

  belongs_to :timeslot
  belongs_to :user_vote

  validates :user_id, :presence => true
end
