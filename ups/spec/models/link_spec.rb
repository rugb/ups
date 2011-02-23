require 'spec_helper'

describe Link do
  before(:each) do
    @attr = {
      :title => "rails tutorial",
      :href => "http://ruby.railstutorial.org/book/ruby-on-rails-tutorial"
    }
  end
  
  it "should create a valid instance" do
    Link.create!(@attr)
  end
  
  describe "validation" do
    
    describe "title" do
      
      it "should reject a NIL title" do
	Link.new(@attr.merge(:title => NIL)).should_not be_valid
      end
      
      it "should reject an empty title" do
	Link.new(@attr.merge(:title => "")).should_not be_valid
      end
      
      it "should reject an title longer than 255 chars" do
	long_title = "a" * 256
	Link.new(@attr.merge(:title => long_title)).should_not be_valid
      end
    end
    
    describe "href" do
      
      it "should reject a NIL href" do
	Link.new(@attr.merge(:href => NIL)).should_not be_valid
      end
      
      it "should reject an empty href" do
	Link.new(@attr.merge(:href => "")).should_not be_valid
      end
      
      it "should reject a href longer than 255 chars" do
	long_href = "http://" + "a" * 256
	Link.new(@attr.merge(:href => long_href)).should_not be_valid
      end
      
      it "should accept url with http" do
	uri = "http://google.de"
	
	Link.new(@attr.merge(:href => uri)).should be_valid
      end
      
      it "should accept uri with https" do
	uri = "https://google.de"
	
	Link.new(@attr.merge(:href => uri)).should be_valid
      end
      
      it "should accept uri with ftp" do
	uri = "ftp://google.de"
	
	Link.new(@attr.merge(:href => uri)).should be_valid
      end
      
      it "should reject invalid (mailto) uri" do
	uri = "mailto://noreply@foobar.com"
	
	Link.new(@attr.merge(:href => uri)).should_not be_valid
      end
    end
  end
end
