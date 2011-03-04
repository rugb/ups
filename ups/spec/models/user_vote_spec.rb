require 'spec_helper'

describe UserVote do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "to_s" do
    it "should return UserVote, if no user or no event present" do
      UserVote.new.to_s.should == "UserVote"
    end

    it "should return user's vote for eventname" do
      UserVote.new(:user => User.new(:name => "hans"), :event => Event.new(:name => "grillen")).to_s.should == "hans's vote for grillen"
    end
  end
end
