require 'spec_helper'

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
    
    it "should reject not existing page ids" do
      page = Page.new @page_attr.merge(:parent_id => @parent_page.id + 1)
      page.should_not be_valid
    end
    
    it "should reject itself as parent" do
      @parent_page.parent_id @parent_page.id
      @parent_page.should_not be_valid
    end
  end
  
  describe "position" do
    
  end
end
