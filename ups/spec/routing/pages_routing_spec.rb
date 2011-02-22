require "spec_helper"

describe PagesController do
  describe "routing" do

    it "recognizes and generates #show with id and int_title" do
      { :get => "/pages/1/foo" }.should route_to(:controller => "pages", :action => "show", :id => "1", :int_title => "foo")
    end
    
    it "recognizes and generates #show with id only" do
      { :get => "/pages/1" }.should route_to(:controller => "pages", :action => "show", :id => "1")
    end
  end
end
