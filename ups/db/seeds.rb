# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# from http://railspikes.com/tags/fixtures
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

guest = Role.ensure(:id => 1, :name => "Guest", :int_name => :guest)
Role.ensure(:id => 2, :name => "User", :int_name => :user)
member = Role.ensure(:id => 3, :name => "Member", :int_name => :member)
admin = Role.ensure(:id => 4, :name => "Administrator", :int_name => :admin)

def pcID
  @@id ||= 0
  @@id += 1
end

def pID
  @@id ||= 0
  @@id += 1
end

if Page.all.empty? || PageContent.all.empty?
  page = Page.ensure(:id => pID, :int_title => :home, :page_type => :page, :enabled => true, :position => pID * 10, :role_id => guest.id)
  page.page_contents.build(:id => pcID, :language_id => 1, :title => "Homepage", :text => "This is the default homepage.", :html => "This is the default homepage.").save
  page.page_contents.build(:id => pcID, :language_id => 2, :title => "Startseite", :text => "Dies ist die Default-Startseite.", :html => "Dies ist die Default-Startseite.").save

  Conf.ensure(:id => 2, :name => :default_page, :value => 1)

  page = Page.ensure(:id => pID, :int_title => :edit_news, :page_type => :page, :enabled => true, :forced_url => "/news", :position => pID * 10, :role_id => guest.id)
  page.page_contents.build(:id => pcID, :language_id => 1, :title => "Blog").save

  adminPage = Page.ensure(:id => pID, :int_title => :admin, :page_type => :page, :enabled =>  true, :position => pID * 10, :role_id => member.id)
  adminPage.edit_role = nil
  adminPage.save
  adminPage.page_contents.build(:id => pcID, :language_id => 1, :title => "Administration").save
  adminPage.page_contents.build(:id => pcID, :language_id => 2, :title => "Verwaltung").save

  page = Page.ensure(:id => pID, :parent_id => adminPage.id, :int_title => :edit_pages, :page_type => :page, :enabled => true, :forced_url => "/pages", :position => pID * 10, :role_id => member.id)
  page.edit_role = nil
  page.save
  page.page_contents.build(:id => pcID, :language_id => 1, :title => "Pages").save
  page.page_contents.build(:id => pcID, :language_id => 2, :title => "Seiten").save

  page = Page.ensure(:id => pID, :parent_id => adminPage.id, :int_title => :edit_categories, :page_type => :page, :enabled => true, :forced_url => "/categories", :position => pID * 10, :role_id => admin.id)
  page.page_contents.build(:id => pcID, :language_id => 1, :title => "Categories").save
  page.page_contents.build(:id => pcID, :language_id => 2, :title => "Kategorien").save

  page = Page.ensure(:id => pID, :parent_id => adminPage.id, :int_title => :edit_users, :page_type => :page, :enabled => true, :forced_url => "/users", :position => pID * 10, :role_id => admin.id)
  page.page_contents.build(:id => pcID, :language_id => 1, :title => "User").save
  page.page_contents.build(:id => pcID, :language_id => 2, :title => "Benutzer").save

  page = Page.ensure(:id => pID, :parent_id => adminPage.id, :int_title => :edit_links, :page_type => :page, :enabled => true, :forced_url => "/links", :position => pID * 10, :role_id => admin.id)
  page.page_contents.build(:id => pcID, :language_id => 1, :title => "Linksmanagment").save
  page.page_contents.build(:id => pcID, :language_id => 2, :title => "Linksverwaltung").save

  page = Page.ensure(:id => pID, :parent_id => adminPage.id, :int_title => :edit_file_uploads, :page_type => :page, :enabled => true, :forced_url => "/file_uploads", :position => pID * 10, :role_id => admin.id)
  page.page_contents.build(:id => pcID, :language_id => 1, :title => "Fileuploads").save
  page.page_contents.build(:id => pcID, :language_id => 2, :title => "Dateiupload").save

  page = Page.ensure(:id => pID, :parent_id => adminPage.id, :int_title => :config, :page_type => :page, :enabled => true, :forced_url => "/config", :position => pID * 10, :role_id => admin.id)
  page.page_contents.build(:id => pcID, :language_id => 1, :title => "Settings").save
  page.page_contents.build(:id => pcID, :language_id => 2, :title => "Einstellungen").save

  vote = Page.ensure(:id => pID, :int_title => :votes, :page_type => :page, :enabled => true, :forced_url => "/events", :position => pID * 10, :role_id => member.id)
  vote.page_contents.build(:id => pcID, :language_id => 1, :title => "Events").save
  vote.page_contents.build(:id => pcID, :language_id => 2, :title => "Termine").save

  page = Page.ensure(:id => pID, :int_title => :calendar, :page_type => :page, :enabled => false, :forced_url => "/calendar", :position => pID * 10, :role_id => member.id)
  page.page_contents.build(:id => pcID, :language_id => 1, :title => "Calendar").save
  page.page_contents.build(:id => pcID, :language_id => 2, :title => "Kalender").save

  page = Page.ensure(:id => pID, :int_title => :projects, :page_type => :page, :enabled => false, :position => pID * 10, :role_id => guest.id)
  page.page_contents.build(:id => pcID, :language_id => 1, :title => "Projects").save
  page.page_contents.build(:id => pcID, :language_id => 2, :title => "Projekte").save
end

category = Category.new
category.category_names.build(:id => 1, :language_id => 2, :name => "Allgemein").save
category.category_names.build(:id => 2, :language_id => 1, :name => "general").save
category.save!

User.ensure(:id => 0)

Conf.web_name = "university project system"
