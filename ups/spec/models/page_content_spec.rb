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
      :int_title => "test_page"
    }
    @page = Page.create!(@attr_page)
  end
  
  it "should create a valid instance" do
    pageContent = @page.page_contents.build(@attr)
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
      
      describe "relation" do
        
        it "should have the right page_id" do
          pageContent = @page.page_contents.build(@attr)
          pageContent.page.int_title.should == @attr_page[:int_title]
        end
      end
    end
    
    describe "language" do
      
      it "should not accept an empty language" do
        PageContent.new(@attr.merge(:language_id => NIL)).should_not be_valid
      end
      
      it "should not have a language_id equal 0" do
        PageContent.new(@attr.merge(:lanuage_id => 0)).should_not be_valid
      end
      
      describe "relation" do
        before(:each) do
          @lang_attr = {
	          :short => "de",
	          :name => "deutsch"
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
  
  describe "validate changing int_title" do
    before(:each) do	
      @lang_default = Conf.get_default_language
      @lang_non_default = Language.create!(:short => "fo", :name => "foobar")
      
      @page_content_1 = @page.page_contents.build(@attr.merge(:language_id => @lang_default.id))
    end
    
    it "should change the int_title (one page_content / default language)" do
      old_int_title = @page_content_1.page.int_title
      
      @page_content_1.update_int_title
      
      old_int_title.should_not == @page_content_1.page.int_title
    end
    
    describe "more than one page_content" do
      before(:each) do
        @page_content_2 = @page.page_contents.build(@attr.merge(:language_id => @lang_non_default.id))
      end
      
      it "should not change the int_title, non default language" do
        old_int_title = @page_content_2.page.int_title
        
        @page_content_2.update_int_title
        
        old_int_title.should == @page_content_2.page.int_title
      end
      
      it "should change the int_title, default language" do
        old_int_title = @page_content_1.page.int_title
        
        @page_content_1.update_int_title
        
        old_int_title.should_not == @page_content_1.page.int_title
      end
    end    
  end
end
