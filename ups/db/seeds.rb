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

Role.all.each { |r| r.destroy }

admin = Role.ensure(:name => "Administrator", :int_name => :admin)
guest = Role.ensure(:name => "Guest", :int_name => :guest)
Role.ensure(:name => "User", :int_name => :user)
Role.ensure(:name => "Member", :int_name => :member)

if Page.all.empty? || PageContent.all.empty?
  page = Page.ensure(:id => 1, :int_title => :home, :page_type => :page,
    :enabled => true, :position => 10, :role_id => guest.id)
  page.page_contents.build(:id => 1, :language_id => 1, :title => "Homepage", :text => "This is the default homepage.").save
  page.page_contents.build(:id => 2, :language_id => 2, :title => "Startseite", :text => "Dies ist die Default-Startseite.").save
  
  Conf.ensure(:id => 2, :name => :default_page, :value => 1)
  
  page = Page.ensure(:id => 2, :int_title => :edit_pages, :page_type => :page,
    :enabled => true, :forced_url => "/news", :position => 100, :role_id =>
  guest.id)
  page.page_contents.build(:id => 3, :language_id => 1, :title => "Blog").save
  
  page = Page.ensure(:id => 3, :int_title => :edit_pages, :page_type => :page,
    :enabled => true, :forced_url => "/pages", :position => 100, :role_id =>
  admin.id)
  page.page_contents.build(:id => 4, :language_id => 1, :title =>
    "Pageadmin").save
  
  page = Page.ensure(:id => 4, :int_title => :edit_categories, :page_type =>
    :page, :enabled => true, :forced_url => "/categories", :position => 110,
    :role_id => admin.id)
  page.page_contents.build(:id => 5, :language_id => 1, :title => "Categoryadmin").save
end

category = Category.ensure(:id => 1)
category.category_names.build(:id => 1, :language_id => 2, :name => "Allgemein").save
category.category_names.build(:id => 2, :language_id => 1, :name => "general").save

User.ensure(:id => 0, :role_id => guest.id)
