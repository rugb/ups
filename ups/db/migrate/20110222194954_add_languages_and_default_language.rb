class AddLanguagesAndDefaultLanguage < ActiveRecord::Migration
  def self.up
    Language.create!(:short => "de", :name => "Deutsch")
    Language.create!(:short => "en", :name => "English")
    Conf.create!(:name => :default_language, :value => "en")
  end
  
  def self.down
    Language.find_by_short("de").destroy
    Language.find_by_short("en").destroy
    Conf.find_by_name(:default_language).destroy
  end
end
