require 'spec_helper'

describe Tag do
  before(:each) do
    @attr = {
      :name => "Test Tag"
    }
  end
  
  it "should create a valid instance" do
    Tag.create!(@attr)
  end
  
  it "should reject duplicates with case insensitive" do
    Tag.create!(@attr)
    Tag.new(@attr.merge(:name => @attr[:name].upcase)).should_not be_valid
  end
end
