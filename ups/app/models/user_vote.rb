# == Schema Information
# Schema version: 20110302161658
#
# Table name: user_votes
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class UserVote < ActiveRecord::Base
  attr_accessible :user_id, :user, :event_id, :event, :votes_attributes

  belongs_to :event
  belongs_to :user

  has_many :votes, :dependent => :destroy
  accepts_nested_attributes_for :votes

  def to_s
    if user.present? && event.present?
      "#{user.name}'s vote for #{event.name}"
    else
      "UserVote"
    end
  end
end
