require 'spec_helper'

describe UsersHelper do
  
  before(:each) do
    @user = User.create!(:name => "Bill Gates", :email => "gates@microsoft.com")
    @user2 = User.new(:name => "Hans Meier", :email => "hans@meier.de")
  end
  
  describe "free users options" do
    it "should be empty if only one user exists" do
      free_users_options(@user).should == []
    end
    
    it "should contain the other users name and id if two users exists" do
      @user2.save
      free_users_options(@user).should == [[@user2.name, @user2.id]]
    end
  end
end
