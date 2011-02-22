require 'spec_helper'

describe PagesController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => 1
      response.should be_success
    end
    
    it "should be successful with int_title" do
      get 'show', :id => 1, :int_title => "foo"
      response.should be_success
    end
    
    it "should be successful with empty int_title" do
      get 'show', :id => 1, :int_title => ""
      response.should be_success
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => 1
      response.should be_success
    end
    
    it "should be successful with int_title" do
      get 'edit', :id => 1, :int_title => "foo"
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      post 'create'
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      delete 'destroy', :id => 1
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "should be successful" do
      put 'update', :id => 1
      response.should be_success
    end
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

end
