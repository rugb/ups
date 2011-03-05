# == Schema Information
# Schema version: 20110303160424
#
# Table name: pages
#
#  id              :integer         not null, primary key
#  parent_id       :integer
#  position        :integer
#  page_type       :string(255)
#  start_at        :datetime
#  enabled         :boolean
#  forced_url      :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  int_title       :string(255)
#  user_id         :integer
#  role_id         :integer
#  edit_role_id    :integer
#  enable_comments :boolean
#

require 'date'

class Page < ActiveRecord::Base
  attr_accessible :parent_id, :page_type, :enabled, :position, :int_title, :forced_url, :start_at, :role_id, :role, :user, :user_id, :enable_comments, :page_contents_attributes, :page_categories_attributes, :file_uploads, :tags_string

  belongs_to :parent, :class_name => "Page", :foreign_key => "parent_id"
  has_many :children, :class_name => "Page", :foreign_key => "parent_id", :dependent => :destroy

  has_many :page_contents, :dependent => :destroy
  accepts_nested_attributes_for :page_contents

  has_many :page_tags, :dependent => :destroy
  has_many :tags, :through => :page_tags

  has_many :page_categories, :dependent => :destroy
  has_many :categories, :through => :page_categories
  accepts_nested_attributes_for :page_categories, :reject_if => proc { |attrs| attrs['checked'] == "0" }

  has_many :comments, :dependent => :destroy
  belongs_to :user
  belongs_to :role
  belongs_to :edit_role, :class_name => "Role"

  has_many :file_uploads

  default_scope :order => "position"

  scope :news, :conditions => {:page_type => :news}, :order => "created_at DESC"
  scope :blog, :conditions => {:forced_url => "/news"}, :limit => 1

  validate do |record|
    # reject pages having itself as parent
    record.errors.add :parent_id, "cannot have itself as parent" if record.parent_id.present? && record.parent_id == record.id

    # page cannot be enabled without int_title
    record.errors.add :enabled, "cannot be true if page has no internal title" if record.enabled && (record.int_title.nil? || record.int_title == "")
  end
  validates_numericality_of :position, :only_integer => true, :greater_than => 0, :allow_nil => true
  validates_inclusion_of :page_type, :in => [:news, :page, :project]
  validates_inclusion_of :enabled, :in => [true, false]
  validates :int_title, :uniqueness => true,  :format => /^[a-z0-9_]{0,255}$/, :allow_nil => true
  validates_numericality_of :role_id, :presence => true, :greater_than => 0
  validates_numericality_of :edit_role_id, :presence => true, :allow_nil => true, :greater_than => 0

  before_validation :destroy_relevant

  def self.projects
    project_page = find_or_initialize_by_int_title :projects
    if project_page.page_contents.empty?
      project_page.parent = nil
      project_page.int_title = :projects
      project_page.enabled = false
      project_page.page_type = :page
      project_page.position = 23
      project_page.role = Role.find_by_int_name :guest
      project_page.save!
      project_page.page_contents.build(:language_id => Language.find_by_short("en").id, :title => "Projects").save
      project_page.page_contents.build(:language_id => Language.find_by_short("de").id, :title => "Projekte").save
    end

    project_page
  end

  def self.project_by_repo(repo)
    page = find_or_initialize_by_int_title(repo.name.tr(" ", "_").downcase.tr("^a-z0-9_", ""))
    if page.page_contents.empty?
      page.parent = projects
      page.enabled = false
      page.page_type = :page
      page.position = 23
      page.role = Role.find_by_int_name :guest
      page.edit_role = Role.find_by_int_name :member
      page.save!
      page.page_contents.build(:language_id => Conf.default_language.id, :title => repo.name, :text => repo.description).save
    end

    page
  end

  def self.new_by_params_and_page_type_and_user(params, page_type, user)
    page = new(params.merge(:page_type => page_type, :enabled => false, :role => Role.find_by_int_name(:guest), :user => user))

    if page_type == :news
      page.edit_role = Role.find_by_int_name :member
      page.parent = Page.blog.first
    end

    page
  end

  def initialize(options = {})
    super(options)

    self.edit_role = Role.find_by_int_name :admin
  end

  def extend
    extend_page_contents
    extend_page_categories
  end

  def to_s
    self.int_title
  end

  def page_type
    pt = read_attribute("page_type")

    pt.to_sym unless pt.nil?
  end

  def page_type=(type)
    write_attribute("page_type", type.to_s) unless type.nil?
  end

  def add_category(category)
    self.categories.push(category) unless self.categories.include?(category)
  end

  def remove_category(category)
    self.categories.delete(category)
  end

  def add_tag(tag)
    self.tags.push(tag) unless self.tags.include?(tag)
  end

  def remove_tag(tag)
    self.tags.delete(tag)
  end

  def tags_string
    self.tags.map do |tag|
      tag.name
    end.join ", "
  end

  def tags_string=(tags_string)
    tags_array = tags_string.split(",").map! { |tag_string| tag_string.strip }
    tags_array.uniq!

    # delete unused tags
    self.tags = self.tags.find_all do |tag|
      tags_array.index tag.name
    end

    # add new tags
    self.tags = tags_array.map do |tag_string|
      Tag.find_or_initialize_by_name tag_string
    end
  end

  # builds unique position string for editing page position
  def position_select
    p = ""
    p += parent_id.to_s unless parent_id.nil?
    p += "_"
    p += position.to_s unless position.nil?

    p
  end

  def position_select=(position_select)
    position_select = position_select.split "_"

    if position_select.empty?
      self.parent = nil
      self.position = nil
    else
      self.parent = Page.find_by_id position_select[0]
      self.position = position_select[1] == "" ? nil : position_select[1].to_i
    end
  end

  def visible?
    enabled && (start_at.nil? or DateTime.now > start_at) && page_contents.any?
  end

  def deleteable?
    !visible? && self != Conf.default_page && forced_url.nil? && !static?
  end

  def activateable?
    !enabled && page_contents.any? && !changed?
  end

  def deactivateable?
    enabled && (role != Role.find_by_int_name(:admin)) && self != Conf.default_page && !static?
  end

  def static?
    edit_role.nil?
  end

  private

  def extend_page_contents
    Language.all.each do |lang|
      found = false
      self.page_contents.each do |page_content|
        found ||= lang == page_content.language
      end
      self.page_contents.build(:language_id => lang.id) unless found
    end
  end

  def extend_page_categories
    self.page_categories.each do |page_category|
      page_category.checked = "1"
    end
    Category.all.each do |cat|
      found = false
      self.page_categories.each do |page_category|
        found ||= cat == page_category.category
      end
      page_category = self.page_categories.build(:category_id => cat.id) unless found
    end
  end

  def destroy_relevant
    self.page_contents = self.page_contents.find_all do |page_content|
      page_content.valid?
    end
    page_categories.each do |page_category|
      page_category.destroy if page_category.checked == "0"
    end
  end
end
