require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
      :openid => "openidfoo",
      :email => "foo@bar.com",
      :name => "James Bond"
    }
  end
  
  it "should create a valid instance" do
    User.create!(@attr)
  end
  
  describe "validation" do
    
    describe "of openid" do
      
      it "should reject a NIL openid" do
	user = User.new(@attr.merge(:openid => NIL))
        user.role_id = Role.find_by_int_name(:user).id
        
        user.should_not be_valid
      end
      
      it "should reject an empty openid" do
	user = User.new(@attr.merge(:openid => ""))
        user.role_id = Role.find_by_int_name(:user).id

        user.should_not be_valid
      end
      
      it "should reject an openid longer than 255" do
	long_openid = "a" * 256
	User.new(@attr.merge(:openid => long_openid)).should_not be_valid
      end
    end
    
    describe "of name" do
      
      it "should reject a NIL name" do
	user = User.new(@attr.merge(:name => NIL))
        user.role_id = Role.find_by_int_name(:user).id

        user.should_not be_valid
      end
      
      it "should reject an empty name" do
	user = User.new(@attr.merge(:name => ""))
        user.role_id = Role.find_by_int_name(:user).id

        user.should_not be_valid
      end
      
      it "should reject a name longer than 255" do
	long_name = "a" * 256
	User.new(@attr.merge(:name => long_name)).should_not be_valid
      end
    end
    
    describe "of email" do
      it "should reject a NIL email" do
	user = User.new(@attr.merge(:email => NIL))
        user.role_id = Role.find_by_int_name(:user).id

        user.should_not be_valid
      end
      
      it "should reject an empty email" do
	user = User.new(@attr.merge(:email => ""))
        user.role_id = Role.find_by_int_name(:user).id

        user.should_not be_valid
      end
      
      it "should reject a email longer than 255" do
	long_email = "a" * 256 + "@bar.com"
	User.new(@attr.merge(:email => long_email)).should_not be_valid
      end
      
      it "should reject an invalid email" do
	addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
	addresses.each do |address|
	  invalid_email_user = User.new(@attr.merge(:email => address))
	  invalid_email_user.should_not be_valid 
	end
      end
    end

    it "should reject empty openid, name, email, without role" do
      user = User.new
      user.role_id = nil

      user.should_not be_valid
    end

    describe "instance methods" do
      before(:each) do
        @user = User.new(@attr)
      end
      it "should have Name: name, E-Mail: email (role) as to_s" do
        @user.to_s.should == "Name: James Bond, E-Mail: foo@bar.com (guest)"
      end

      it "should return an array of symbols" do
        @user.role_symbols.should == [:guest]
      end
    end
  end
end
