require 'spec_helper'
require 'date'

describe Page do
  before(:each) do
    @page_attr_minimal = {:type => :page, :enabled => true}
    @page_attr = {:type => :page, :enabled => true, :int_title => "testpage"}
  end
  
  it "should be valid with minimum requirements" do
    page = Page.new @page_attr_minimal
    page.should be_valid
  end
  
  it "should create" do
    Page.create! @page_attr
  end
  
  describe "parent_id" do
    before(:each) do
      @parent_page = Page.create!(@page_attr_minimal)
    end
    
    it "should accept nil" do
      page = Page.new @page_attr_minimal.merge(:parent_id => nil)
      page.should be_valid
    end
    
    it "should accept valid parent page ids" do
      page = Page.new @page_attr.merge(:parent_id => @parent_page.id)
      page.should be_valid
    end
    
    it "should reject not existing page ids at save" do
      page = Page.new @page_attr.merge(:parent_id => @parent_page.id + 1)
      page.save
    end
    
    it "should reject itself as parent at save" do
      @parent_page.parent_id @parent_page.id
      @parent_page.save
    end
  end
  
  describe "position" do
    it "should accept nil" do
      page = Page.new @page_attr_minimal.merge(:position => nil)
      page.should be_valid
    end
    
    it "should reject duplicates with pages with same parent at save" do
      Page.create! @page_attr_minimal.merge(:position => 1)
      Page.create! @page_attr_minimal.merge(:position => 1)
    end
    
    it "should accept an integer greater than 0" do
      page = Page.new @page_attr_minimal.merge(:position => 1)
      page.should_not be_valid
    end
    
    it "should reject values below 0" do
      page = Page.new @page_attr_minimal.merge(:position => -23)
      page.should_not be_valid
    end
  end
  
  describe "type" do
    it "should reject nil" do
      page = Page.new @page_attr_minimal.merge(:type => nil)
      page.should_not be_valid
    end
    
    it "should accept :news" do
      page = Page.new @page_attr_minimal.merge(:type => :news)
      page.should_not be_valid
    end
    
    it "should accept :page" do
      page = Page.new @page_attr_minimal.merge(:type => :page)
      page.should_not be_valid
    end
    
    it "should reject anything" do
      page = Page.new @page_attr_minimal.merge(:type => :foobar)
      page.should_not be_valid
    end
  end
  
  describe "start_time" do
    it "should accept nil" do
      page = Page.new @page_attr_minimal.merge(:start_time => nil)
      page.should be_valid
    end
    
    it "should accept any timestamp" do
      page = Page.new @page_attr_minimal.merge(:start_time => DateTime.now)
    end
  end
  
  describe "enabled" do
    it "should reject nil" do
      page = Page.new @page_attr_minimal.merge(:enabled => nil)
      page.should_not be_valid
    end
    
    it "should accept a boolean" do
      page = Page.new @page_attr_minimal.merge(:enabled => false)
      page.should be_valid
    end
  end
end
