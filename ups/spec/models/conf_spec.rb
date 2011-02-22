require 'spec_helper'

describe Conf do
  it "should have a to_s method" do
    conf = Conf.new(:name => "a", :value => "b")
    conf.should respond_to(:to_s)
  end
  
  it "should have a name: value to_s output" do
    conf = Conf.new(:name => "a", :value => "b")
    conf.to_s.should == conf.name + ": " + conf.value
  end
  
  describe "attributes" do
    it "should accept a name string between 1 and 50 chars" do
      conf = Conf.new(:name => "a" * 23, :value => "test")
      conf.should be_valid
    end
    
    it "should reject names longer than 50 chars" do
      conf = Conf.new(:name => "a" * 51, :value => "test")
      conf.should_not be_valid
    end
    
    it "should reject nil name" do
      conf = Conf.new(:name => nil, :value => "test")
      conf.should_not be_valid
    end
    
    it "should accept nil value" do
      conf = Conf.new(:name => "test", :value => nil)
      conf.should be_valid
    end
    
    it "should accept any value string between 1 and 255 chars" do
      conf = Conf.new(:name => "test", :value => "a" * 255)
      conf.should be_valid
    end
    
    it "should reject values longer than 255 chars" do
      conf = Conf.new(:name => "test", :value => "a" * 256)
      conf.should_not be_valid
    end
  end
  
  describe "default language" do
    it "should have a get_default_language method" do
      Conf.should respond_to(:get_default_language)
    end
    
    it "should not return nil" do
      Conf.get_default_language.should_not == nil
    end
    
    it "should have a set_default_language method" do
      Conf.should respond_to(:set_default_language)
    end
    
    it "should reject nil" do
      Conf.set_default_language(nil).should_not be_valid
    end
    
    it "should store the right language" do
      default_lang = Conf.get_default_language
      lang = Language.create!(:short => "xx", :name => "Kaesoaili")
      Conf.set_default_language lang
      Conf.get_default_language.should == lang
      
      Conf.set_default_language default_lang
      Conf.get_default_language.should == default_lang
    end
  end
end
