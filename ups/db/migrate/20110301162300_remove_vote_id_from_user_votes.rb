class RemoveVoteIdFromUserVotes < ActiveRecord::Migration
  def self.up
    remove_column :user_votes, :vote_id
  end

  def self.down
    add_column :user_votes, :vote_id, :integer
  end
end
