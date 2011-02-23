require 'spec_helper'

describe Category do
  before(:each) do
    @attr = {
      :name => "News",
      :language => "en"
    }
  end
  
  it "should create a valid instance" do
    Category.new(@attr)
  end
  
  describe "validation" do
    
    it "should reject with NIL name" do
      Category.new(@attr.merge(:name => NIL)).should_not be_valid
    end
    
    it "should reject with empty name" do
      Category.new(@attr.merge(:name => "")).should_not be_valid
    end
    
    it "should reject with NIL language" do
      Category.new(@attr.merge(:language => NIL)).should_not be_valid
    end
    
    it "should reject with empty language" do
      Category.new(@attr.merge(:language => "")).should_not be_valid
    end
    
    it "should accept with long language" do
      
    end
    
    it "should accept with language id" do
      
    end
  end
end
