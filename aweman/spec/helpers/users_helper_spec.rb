require 'spec_helper'

describe UsersHelper do
  describe "free users options" do
    before(:each) do
      @user = User.create!(:name => "Bill Gates", :email => "gates@microsoft.com")
      @user2 = User.new(:name => "Hans Meier", :email => "hans@meier.de")
    end
    
    it "should be empty if only one user exists" do
      free_users_options(@user).should == []
    end
    
    it "should contain the other users name and id if two users exists" do
      @user2.save
      free_users_options(@user).should == [[@user2.name, @user2.id]]
    end
  end
  
  describe "groups options" do
    before(:each) do
      @group = Group.new(:nr => 23)
    end
    
    it "should be empty if no group exists" do
      groups_options.should == []
    end
    
    it "should contain one groups number and id if one group exists" do
      @group.save
      groups_options.should == [[@group.nr, @group.id]]
    end
  end
end
