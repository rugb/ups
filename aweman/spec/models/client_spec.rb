require 'spec_helper'

describe Client do
  before(:each) do
    @attr = {
      :name => "foo bar client"
    }
  end
  
  it "should create a new instance given valid attrs" do
    Client.create!(@attr)
  end
  
  describe "validation" do
    
    it "should have a not empty name" do
      no_name_client = Client.create(@attr.merge(:name => ""))
      no_name_client.should_not be_valid
    end
    
    it "should reject names that are too long" do
      long_name = "a" * 51
      long_name_client = Client.new(@attr.merge(:name => long_name))
      long_name_client.should_not be_valid
    end
    
    it "should reject duplicate names" do
      Client.create!(@attr)
      duplicate_client = Client.new(@attr)
      duplicate_client.should_not be_valid
    end
  end
end
