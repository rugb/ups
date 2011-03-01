class UserVote < ActiveRecord::Base
  attr_accessible :votes_attributes
  
  belongs_to :event
  belongs_to :user

  has_many :votes, :dependent => :destroy
  accepts_nested_attributes_for :votes
end
