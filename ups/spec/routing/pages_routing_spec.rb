require "spec_helper"

describe PagesController do
  describe "routing" do
    it "recognizes and generates #show with id and int_title" do
      { :get => "/pages/1/foo" }.should route_to(:controller => "pages", :action => "show", :id => "1", :int_title => "foo")
    end
    
    it "recognizes and generates #show with id and empty int_title" do
      { :get => "/pages/1/" }.should route_to(:controller => "pages", :action => "show", :id => "1")
    end
    
    it "recognizes and generates #show with id only" do
      { :get => "/pages/1" }.should route_to(:controller => "pages", :action => "show", :id => "1")
    end
    
    describe "forced_url" do
      before(:each) do
        @page_attr = {:page_type => :page, :enabled => false, :forced_url => "pages/1/test_page"}
      end
      
      it "should accept a valid routed relative path" do
        page = Page.new(@page_attr)
        { :get => page.forced_url }.should be_routable
      end
      
      it "should reject a not routed relative path" do
        page = Page.new(@page_attr.merge(:forced_url => "That should fail."))
        { :get => page.forced_url }.should_not be_routable
      end
    end
  end
end
