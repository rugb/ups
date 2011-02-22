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
      get 'show'
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
      get 'edit'
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
      delete 'destroy'
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "should be successful" do
      put 'update'
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
