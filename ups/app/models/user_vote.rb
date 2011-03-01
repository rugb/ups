class UserVote < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  has_many :votes
end
