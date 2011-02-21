require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :name => "Foobar",
	    :email => "foo@bar.de"
    }
  end
  
  it "should create a new instance given valid attrs" do
    User.create!(@attr)
  end
  
  describe "validation" do
    
    it "should have a not empty name" do
      no_name_user = User.create(@attr.merge(:name => ""))
      no_name_user.should_not be_valid
    end
    
    it "should have a valid email" do
      no_email_user = User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
    end
    
    it "should reject names that are too long" do
      long_name = "a" * 51
      long_name_user = User.new(@attr.merge(:name => long_name))
      long_name_user.should_not be_valid
    end
    
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end
    
    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end
    
    it "should reject duplicate email addresses" do
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
    
    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
  end
  
  describe "group association" do
    before(:each) do
      @group = Group.create(:nr => 25)
      @user = @group.users.create(@attr)
    end
    
    it "should have a group attribute" do
      @user.should respond_to(:group)
    end
    
    it "should have the right associated group" do
      @user.group_id.should == @group.id
      @user.group == @group
    end
  end
  
  describe "group building" do
    before(:each) do
      @user = User.create(@attr)
      @user2 = User.create(@attr.merge(:name => "James Bond", :email => "oo7@mi6.co.uk"))
    end
    
    it "should have a method group_with!" do
      @user.should respond_to(:group_with!)
    end
    
    it "should generate a group with both users" do
      @group = @user.group_with!(@user2)
      @group.should be_valid
      @group.users.should include(@user)
      @group.users.should include(@user2)
    end
    
    it "should reject nil" do
      @user.group_with!(nil).should == nil
    end
  end
end
