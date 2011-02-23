require 'spec_helper'

describe Language do
  before(:each) do 
    @attr = {
      :short => "es",
      :name => "Spanisch"
    }
  end
  
  it "should create a valid instance" do
    Language.create!(@attr)
  end
  
  it "should have a to_s method" do
    lang = Language.new(@attr)
    lang.should respond_to(:to_s)
  end
  
  it "should have a name (short) to_s output" do
    lang = Language.new(@attr)
    lang.to_s.should == "#{@attr[:name]} (#{@attr[:short]})"
  end
  
  describe "validation" do
    
    describe "short" do
      
      it "should not accept a NIL short" do
        Language.new(@attr.merge(:short => NIL)).should_not be_valid
      end
      
      it "should not accept an empty short" do
        Language.new(@attr.merge(:short => "")).should_not be_valid
      end
      
      it "should reject short shorter than 2" do
        Language.new(@attr.merge(:short => "d")).should_not be_valid
      end
      
      it "should reject short longer than 2" do
        Language.new(@attr.merge(:short => "ddd")).should_not be_valid
      end
      
      it "should reject duplicates" do
	Language.create!(@attr)
	Language.new(@attr.merge(:name => "foo")).should_not be_valid
      end
    end
    
    describe "name" do
      
      it "should not accept a NIL name" do
        Language.new(@attr.merge(:name => NIL)).should_not be_valid
      end
      
      it "should not accept an empty name" do
        Language.new(@attr.merge(:name => "")).should_not be_valid
      end
      
      it "should not accept name longer than 255" do
        long_name = "a" * (255+1)
        Language.new(@attr.merge(:name => long_name)).should_not be_valid
      end
      
      it "should reject duplicates" do
	Language.create!(@attr)
	Language.new(@attr.merge(:short => "bl")).should_not be_valid
      end
    end
  end
  
  describe "find_by_any" do
    before(:each) do
      @lang = Language.create!(@attr)
    end
    
    it "should find by id" do
      Language.find_by_any(@lang.id).should == @lang
    end
    
    it "should find by short" do
      Language.find_by_any(@lang.short).should == @lang
    end
    
    it "should find by name" do
      Language.find_by_any(@lang.name).should == @lang
    end
  end
end
