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
      Category.new(@attr.merge(:language => Language.first.name)).should be_valid
    end
    
    it "should accept with language id" do
      Category.new(@attr.merge(:language => Language.first.id)).should be_valid
    end
  end
  
  describe "get_or_net test" do
    before(:each) do
      @attr = { 
	:name => "grillen",
	:language => "de"
      }
    end
    
    it "should return a new instance" do
      c = Category.get_or_new(@attr)
      
      c.should be_new_record
    end
    
    it "should return an existing instance" do
      c = Category.get_or_new(@attr)
      c.save!
      
      Category.get_or_new(:id => c.id).should_not be_new_record
    end
  end
end
