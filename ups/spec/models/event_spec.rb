require 'spec_helper'

describe Event do
  before(:each) do
    @user = User.new(:name => "test user", :email => "foo@bar.com", :openid => "openid")
    @user.role_id = Role.find_by_int_name(:member).id
    @attr = {
      :name => "Fachgespraech",
      :location => "MZH",
      :user_id => @user.id
      }
  end

  it "should create an valid instance" do
    Event.create!(@attr)
  end

  describe "validation" do

    describe "of name" do
      it "should reject a blank name" do
        Event.new(@attr.merge(:name => nil)).should_not be_valid
      end

      it "should reject a too long name" do
        long_name = "a" * 256
        Event.new(@attr.merge(:name => long_name)).should_not be_valid
      end
    end

    describe "of location" do
      it "should reject a blank location" do
        Event.new(@attr.merge(:location => nil)).should_not be_valid
      end

      it "should reject a too long location" do
        long_location = "a" * 256
        Event.new(@attr.merge(:location => long_location)).should_not be_valid
      end
    end

    describe "of user" do
      it "should reject without user" do
        Event.new(@attr.merge(:user_id => nil)).should_not be_valid
      end
    end
  end

  describe "relation to timeslot" do
    pending " not implemented yet."
  end

end
