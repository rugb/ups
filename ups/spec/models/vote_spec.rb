require 'spec_helper'

describe Vote do
  before(:each) do
    @user = User.new(:name => "test user", :email => "foo@bar.com", :openid => "openid")
    @attr = {
      :user_id => @user.id
      }
  end
  
end
