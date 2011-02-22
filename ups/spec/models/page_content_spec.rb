require 'spec_helper'

describe PageContent do
  before(:each) do
    @attr = {
      :title => "Foo Title",
      :text => "page text",
      :excerpt => "page",
      :page_id => 1,
      :language_id => 1
      }
  end
  
  it "should create a valid instance" do
    page = Page.create!(:type => :page, :enabled => true)
    pageContent = Page.page_contents.build
  end
  
  describe "validation" do
    
    describe "title" do
      it "should not accept a NIL title" do
	PageContent.new(@attr.merge(:title => NIL)).should_not be_valid
      end
      
      it "should not accept an empty title" do
	PageContent.new(@attr.merge(:title => "")).should_not be_valid
      end
      
      it "should reject title that are too long" do
	long_title = "a" * 51
	PageContent.new(@attr.merge(:title => long_title)).should_not be_valid
      end
    end
    
    describe "page_id" do
      it "should not accept a NIL page_id" do
	PageContent.new(@attr.merge(:page_id => NIL)).should_not be_valid
      end
    
      it "should not accept a page_id equal/less 0" do
	PageContent.new(@attr.merge(:page_id => 0)).should_not be_valid
      end
    end
    
    describe "language" do
      it "should not accept an empty language" do
	PageContent.new(@attr.merge(:language_id => NIL)).should_not be_valid
      end
    
      it "should not have a language_id equal 0" do
	PageContent.new(@attr.merge(:lanuage_id => 0)).should_not be_valid
      end
    end
  end
end
