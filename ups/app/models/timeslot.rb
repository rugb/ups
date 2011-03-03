# == Schema Information
# Schema version: 20110302161658
#
# Table name: timeslots
#
#  id         :integer         not null, primary key
#  start_at   :datetime
#  end_at     :datetime
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  gevent_id  :string(255)
#

class Timeslot < ActiveRecord::Base
  attr_accessible :start_at, :end_at, :votes_attributes, :choosen

  belongs_to :event
  has_many :votes, :dependent => :destroy

  accepts_nested_attributes_for :votes

  validates :start_at, :presence => true
  validates :end_at, :presence => true

  default_scope :order => "timeslots.start_at"

  validate do |timeslot|
    timeslot.errors.add :start_at, "is after end_at" if timeslot.start_at.present? && timeslot.end_at.present? && timeslot.start_at > timeslot.end_at
  end

  def vote_for_user_vote(user_vote)
    votes.find_by_user_vote_id user_vote.id
  end

  def acks
    (votes.find_all { |vote| vote.ack }).size
  end

  def choosen?
    @choosen == "1"
  end

  def choosen
    @choosen
  end

  def choosen=(c)
    @choosen = c
  end
end
