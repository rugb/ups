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
  attr_accessible :timeslot_id, :user_vote_id, :ack

  belongs_to :timeslot
  belongs_to :user_vote

  #validates :user_vote_id, :presence => true

  def to_s
    "Vote-> User: #{user_vote.user.name}, TimeSlotID: #{timeslot_id}"
  end
end
