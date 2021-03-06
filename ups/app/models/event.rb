# == Schema Information
# Schema version: 20110302161658
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
#  finished    :boolean
#

class Event < ActiveRecord::Base
  attr_accessible :name, :user_id, :location, :end_at, :description, :finished, :timeslots_attributes, :user_votes_attributes

  belongs_to :user
  has_many :timeslots, :dependent => :destroy
  accepts_nested_attributes_for :timeslots, :allow_destroy => true

  has_many :user_votes, :dependent => :destroy
  accepts_nested_attributes_for :user_votes

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :location, :presence => true, :length => { :maximum => 255 }
  validates :user_id, :presence => true

  def votable?
    end_at.nil? || end_at? && end_at.future? && !finished?
  end

  def editable_for_user?(user, admin = false)
    !finished? && (self.user == user || admin)
  end
end
