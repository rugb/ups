require 'spec_helper'

describe CategoryName do
  before(:each) do
    @attr_de = {
      :name => "Nachrichten",
      :language_id => Language.find_by_short("de").id
    }
  end
  
  it "should create a valid instance" do
    CategoryName.create!(@attr_de)
  end
  
  describe "validation" do
    
    describe "of name" do
      
      it "should reject a NIL name" do
	CategoryName.new(@attr_de.merge(:name => NIL)).should_not be_valid
      end
      
      it "should reject an empty name" do
	CategoryName.new(@attr_de.merge(:name => "")).should_not be_valid
      end
      
      it "should reject duplicates" do
	category_name_1 = CategoryName.create!(@attr_de)
	CategoryName.new(@attr_de).should_not be_valid
      end
    end
    
    describe "of language_id" do
      
      it "should reject a NIL language_id" do
	CategoryName.new(@attr_de.merge(:language_id => NIL)).should_not be_valid
      end
      
      it "should reject a language_id of 0" do
	CategoryName.new(@attr_de.merge(:language_id => 0)).should_not be_valid
      end
      
      it "should have the right language" do
	category_name_1 = CategoryName.new(@attr_de)
	category_name_1.language.short.should == Language.find_by_short("de").short
      end
    end
  end  
end
