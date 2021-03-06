require 'spec_helper'

describe PageContent do
  before(:each) do
    @attr = {
      :title => "Foo Title",
      :text => "page text",
      :excerpt => "page",
      :language_id => 1
    }
    
    @attr_page = {
      :page_type => :page,
      :enabled => true,
      :int_title => "test_page",
      :role_id => 1
    }
    @page = Page.create!(@attr_page)
  end
  
  it "should create a valid instance" do
    pageContent = @page.page_contents.build(@attr)
  end
  
  describe "validation" do
    
    describe "of title" do
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
    
    describe "of page_id" do
      
      it "should accept a NIL page_id" do
        pc = PageContent.new(@attr)
        pc.page_id = NIL
        
        pc.should be_valid
      end
      
      it "should not accept a page_id equal/less 0" do
        pc = PageContent.new(@attr)
        pc.page_id = 0
        
        pc.should_not be_valid
      end
      
      describe "of relation" do
        
        it "should have the right page_id" do
          pageContent = @page.page_contents.build(@attr)
          pageContent.page.int_title.should == @attr_page[:int_title]
        end
      end
    end
    
    describe "of language" do
      
      it "should not accept an empty language" do
        PageContent.new(@attr.merge(:language_id => NIL)).should_not be_valid
      end
      
      it "should not have a language_id equal 0" do
        PageContent.new(@attr.merge(:language_id => 0)).should_not be_valid
      end
      
      describe "relation" do
        before(:each) do
          @lang_attr = {
	    :short => "es",
	    :name => "spanisch"
          }
          @lang = Language.create!(@lang_attr)
        end
        
        it "should have the right language" do
          page_content = @page.page_contents.build(@attr.merge(:language_id => @lang.id))
          
          page_content.language.short.should == @lang_attr[:short]
        end
      end
    end
  end
end
