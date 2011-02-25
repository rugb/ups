require 'spec_helper'

describe PagesHelper do
  describe "page_title" do
    it "should return page_title in wanted language"
  end
  
  describe "page_excerpt"
    it "should return page_excerpt in wanted language"
  
  describe "make_page_path" do
    it "should return a routable path"
    
    it "should route to given page"
  end
  
  describe "get_page_contents_by_all_languages" do
    it "should contain a key for every language"
    
    it "should include values for existing page_contents"
  end
  
  describe "possible_page_position_options" do
    it "should do some html stuff" do
      possible_page_position_options(Page.first).should_not == ""
    end
  end
  
  describe "make_page_title"
  
  describe "make_html_list" do
    it "should return an blank string if array is empty" do
      make_html_list([]).should == ""
    end
    
    it "should return a html list" do
      make_html_list(["a", "b"]).should == "<ul><li>a</li><li>b</li></ul>"
    end
  end
end
