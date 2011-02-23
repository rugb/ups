# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# extend with helper method for ensuring / updating seed objects
class ActiveRecord::Base
  # given a hash of attributes including the ID, look up the record by ID. 
  # If it does not exist, it is created with the rest of the options. 
  # If it exists, it is updated with the given options. 
  #
  # Raises an exception if the record is invalid to ensure seed data is loaded correctly.
  # 
  # Returns the record.
  def self.ensure(options = {})
    id = options.delete(:id)
    record = find_by_id(id) || new
    record.id = id
    record.attributes = options
    record.save!
    
    record
  end
end

Language.ensure(:id => 1, :short => "en", :name => "English")
Language.ensure(:id => 2, :short => "de", :name => "Deutsch")

Conf.ensure(:id => 1, :name => :default_language, :value => "en")

if Page.all.empty?
  page = Page.ensure(:id => 1, :int_title => :home, :page_type => :page, :enabled => true)
  PageContent.ensure(:id => 1, :page_id => 1, :page => page, :language_id => 2, :title => "Startseite", :text => "Dies ist die Default-Startseite.")
  
  Conf.ensure(:id => 2, :name => :default_page, :value => 1)
end