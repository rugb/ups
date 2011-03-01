# == Schema Information
# Schema version: 20110301133921
#
# Table name: events
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  user_id     :integer
#  location    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  end_at      :datetime
#  description :text
#

class Event < ActiveRecord::Base
  attr_accessible :name, :user_id, :location, :description, :timeslots_attributes, :user_vote_attributes

  belongs_to :user
  has_many :timeslots, :dependent => :destroy
  accepts_nested_attributes_for :timeslots

  has_many :user_votes, :dependent => :destroy
  accepts_nested_attributes_for :user_votes

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :location, :presence => true, :length => { :maximum => 255 }
  validates :user_id, :presence => true
end
