require 'spec_helper'

describe ApplicationController do
  describe "accepted_languages" do
    it "should be empty without header" do
      controller.accepted_languages.should == []
    end
    
    it "should return languages listet by http request" do
      controller.request.env['HTTP_ACCEPT_LANGUAGE'] = "de-de,de;q=0.8,en-us;q=0.5,en;q=0.3"
      controller.accepted_languages.should == ["de", "de", "en", "en"]
    end
  end
  
  describe "wanted_languages" do
    it "should not include nil" do
      controller.wanted_languages.should_not include(nil)
    end
    
    it "should include default language" do
      controller.wanted_languages.should include(Conf.get_default_language)
    end
    
    it "should include existing accepted languages" do
      controller.request.env['HTTP_ACCEPT_LANGUAGE'] = "de-de,de;q=0.8,en-us;q=0.5,en;q=0.3"
      languages = controller.accepted_languages
      languages.each do |language|
        language = Language.find_by_short(language)
        controller.wanted_languages.should include(language) unless language.nil?
      end
    end
    
    it "should include existing wanted languge" do
      language = Language.first
      controller.params[:language_short] = language.short
      controller.wanted_languages.should include(language)
    end
  end
  
  describe "select_by_language_id" do
    it "should select only-existing language, even if not wanted" do
      language = Language.create!(:short => "xx", :name => "Ulumulugulu")
      elements = [PageContent.new(:language_id => language.id)]
      controller.select_by_language_id(elements).should == elements.first
    end
    
    it "should select first wanted matched language" do
      wanted_language = controller.wanted_languages.first
      elements = Language.all.map do |language|
        PageContent.new(:language_id => language.id)
      end
      controller.select_by_language_id(elements).language.should == wanted_language
    end
  end
end
