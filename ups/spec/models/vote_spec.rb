require 'spec_helper'

describe Vote do
  before(:each) do
    @user = User.new(:name => "test user", :email => "foo@bar.com", :openid => "openid")
    @attr = {
      :ack => true
#      :timeslot_id => @timeslot.id
      }
  end

  it "should create a valid instance" do
    Vote.create!(@attr)
  end

  describe "validation" do
    describe " of user_id" do
      it "should reject empty user_id" do
      end
    end
  end
  
end
