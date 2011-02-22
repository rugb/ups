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
  
  describe "project association" do
    before(:each) do
      @client = Client.create(@attr)
    end
    
    it "should have a projects attribute" do
      @client.should respond_to(:projects)
    end
  end
  
  it "should convert to string" do
    client = Client.new(@attr)
    
    client.to_s.should == client.name.to_s
  end
end
