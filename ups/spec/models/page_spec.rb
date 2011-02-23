require 'spec_helper'
require 'date'

describe Page do
  before(:each) do
    @page_attr_minimal = {:page_type => :page, :enabled => false}
    @page_attr = {:page_type => :page, :enabled => true, :int_title => "testpage"}
  end
  
  it "should be valid with minimum requirements" do
    page = Page.new @page_attr_minimal
    page.should be_valid
  end
  
  it "should create" do
    Page.create! @page_attr
  end
  
  it "should be sorted by position"
  
  it "should not be possible to destroy the default_page"
  
  it "should not be possible to destroy a page with forced_url"
  
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
    
    it "should reject itself as parent" do
      @parent_page.parent_id= @parent_page.id
      @parent_page.should_not be_valid
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
      page.should be_valid
    end
    
    it "should reject values below 0" do
      page = Page.new @page_attr_minimal.merge(:position => -23)
      page.should_not be_valid
    end
  end
  
  describe "type" do
    it "should reject nil" do
      page = Page.new @page_attr_minimal.merge(:page_type => nil)
      page.should_not be_valid
    end
    
    it "should accept :news" do
      page = Page.new @page_attr_minimal.merge(:page_type => :news)
      page.should be_valid
    end
    
    it "should accept :page" do
      page = Page.new @page_attr_minimal.merge(:page_type => :page)
      page.should be_valid
    end
    
    it "should reject anything" do
      page = Page.new @page_attr_minimal.merge(:page_type => :foobar)
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
    
    it "should reject true, if page has no int_title" do
      page = Page.new @page_attr_minimal.merge(:int_title => "", :enabled => true)
      page.should_not be_valid
    end
  end
  
  describe "forced_url" do
    it "should accept nil" do
      page = Page.new @page_attr_minimal.merge(:forced_url => nil)
      page.should be_valid
    end
    
    it "should accept a string" do
      page = Page.new @page_attr_minimal.merge(:forced_url => "abc")
      page.should be_valid
    end
  end
  
  describe "int_title" do
    it "should acccept nil" do
      page = Page.new @page_attr_minimal.merge(:int_title => nil)
      page.should be_valid
    end
    
    it "should accept a string containing a-z, 0-9 and _" do
      page = Page.new @page_attr_minimal.merge(:int_title => "titi_tutu2")
      page.should be_valid
    end
    
    it "should reject a string containing other letters than a-z, 0-9 and _" do
      page = Page.new @page_attr_minimal.merge(:int_title => "We love AWE11")
      page.should_not be_valid
    end
    
    it "should reject a string with more than 256 chars" do
      page = Page.new @page_attr_minimal.merge(:int_title => "a" * (255 + 1))
      page.should_not be_valid
    end
    
    it "should reject duplicates of int_title" do
      Page.create! @page_attr
      page = Page.new @page_attr
      page.should_not be_valid
    end
  end
  
  describe "relation to PageContent" do
    it "should have a page_contents method" do
      page = Page.create!(@page_attr)
      page.should respond_to(:page_contents)
    end
  end
  
  describe "relation to Category" do
    before(:each) do
      @page = Page.create!(@page_attr)
    end
    
    it "should create a new category" do
      category = @page.categories.build(:name => "Grillen", :language => "de")
      
      @page.categories.should include(category)
    end
    
    describe "existing category" do
      before(:each) do
	@category = Category.create!(:name => "Grillen", :language => "de")
      end
      
      it "should add existing category" do
	@page.add_category(@category)
	
	@page.categories.should include(@category)
      end
      
      it "should not add a category twice" do
	@page.add_category(@category)
	@page.add_category(@category)
	
	@page.categories.count.should == 1
      end
      
      it "should remove an existing category" do
	@page.add_category(@category)
	@page.remove_category(@category)
	
	@page.categories.should_not include(@category)
      end
    end
  end
  
  describe "relation to parent" do
    it "may have a parent"
  end
  
  describe "relation to children" do
    it "may have children"
  end
end
