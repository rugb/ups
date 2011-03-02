class RenameUserIdToUserVoteInVotes < ActiveRecord::Migration
  def self.up
    rename_column :votes, :user_id, :user_vote_id
  end

  def self.down
    rename_column :votes, :user_vote_id, :user_id
  end
end
