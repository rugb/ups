require 'spec_helper'

describe Comment do
  before(:each) do
    @attr = {
      :text => "comment text",
      :name => "anonymous user",
      :email => "foo@bar.com",
      :user_id => 1
    }
  end
  
  it "should create a valid instance" do
    Comment.create!(@attr).should be_valid
  end
  
  describe "validation" do
    
    describe "of text" do
      it "should reject a NIL text" do
	Comment.new(:text => NIL).should_not be_valid
      end
      
      it "should reject an empty text" do
	Comment.new(:text => "").should_not be_valid
      end
    end
  end
  
  describe "user info" do
    
    describe "without name/email" do
      before(:each) do
	@attr_wo_name = @attr.merge(:name => NIL, :email => NIL)
      end
      
      it "should reject without userinfo" do
	Comment.new(@attr_wo_name.merge(:user_id => NIL)).should_not be_valid
      end
      
      it "should reject with invalid user_id" do
	Comment.new(@attr_wo_name.merge(:user_id => 0)).should_not be_valid
      end
    end
    
    describe "invalid name/email (without user_id)" do
      before(:each) do
	@attr_wo_user_id = @attr.merge(:user_id => NIL)
      end
      
      it "should reject with invalid name" do
	Comment.new(@attr_wo_user_id.merge(:name => NIL)).should_not be_valid
      end
      
      it "should reject with too long name" do
	long_name = "a" * 256
	Comment.new(@attr_wo_user_id.merge(:name => long_name)).should_not be_valid
      end
      
      it "should reject with invalid email" do
	addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
	addresses.each do |address|
	  invalid_email_comment = Comment.new(@attr_wo_user_id.merge(:email => address))
	  invalid_email_comment.should_not be_valid 
	end
      end
      
      it "should reject too long email" do
	long_email = "foo" + 'a' * 255 + "@bar.com"
	Comment.new(@attr_wo_user_id.merge(:email => long_email)).should_not be_valid
      end
    end
  end
end
