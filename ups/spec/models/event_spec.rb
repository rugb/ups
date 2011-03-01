require 'spec_helper'

describe Event do
  before(:each) do
    @user = User.new(:name => "test user", :email => "foo@bar.com", :openid => "openid")
    @user.role_id = Role.find_by_int_name(:member).id
    @attr = {
      :name => "Fachgespraech",
      :ort => "MZH",
      :user_id => 1
      }
  end

  it "should create an valid instance" do
    Event.create!(@attr)
  end

end
