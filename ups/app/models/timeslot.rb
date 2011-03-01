# == Schema Information
# Schema version: 20110301093539
#
# Table name: timeslots
#
#  id         :integer         not null, primary key
#  start_at   :datetime
#  end_at     :datetime
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Timeslot < ActiveRecord::Base
  attr_accessible :start_at, :end_at, :votes_attributes

  belongs_to :event
  has_many :votes, :dependent => :destroy

  accepts_nested_attributes_for :votes

  validates :start_at, :presence => true
  validates :end_at, :presence => true

  validate do |timeslot|
    timeslot.errors.add :start_at, "is after end_at" if timeslot.start_at.present? && timeslot.end_at.present? && timeslot.start_at > timeslot.end_at
  end
end
