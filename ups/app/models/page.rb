class Page < ActiveRecord::Base
  attr_accessible :parent_id, :page_type, :enabled, :position, :int_title, :forced_url
  
  belongs_to :parent, :class_name => "Page", :foreign_key => "parent_id"
  has_many :children, :class_name => "Page", :foreign_key => "parent_id", :dependent => :destroy
  
  has_many :page_contents, :dependent => :destroy

  has_many :page_tags, :dependent => :destroy
  has_many :tags, :through => :page_tags
  
  has_many :page_categories, :dependent => :destroy
  has_many :categories, :through => :page_categories
  
  has_many :comments
  belongs_to :user
  
  validate do |record|
    # reject pages having itself as parent
    record.errors.add :parent_id, "cannot have itself as parent" if !record.parent_id.nil? && record.parent_id == record.id
    
    # page cannot be enabled without int_title
    record.errors.add :enabled, "connot be true if page has no internal title" if record.enabled && (record.int_title.nil? || record.int_title == "")
  end
  validates_numericality_of :position, :only_integer => true, :greater_than => 0, :allow_nil => true
  validates_inclusion_of :page_type, :in => [:news, :page]
  validates_inclusion_of :enabled, :in => [true, false]
  validates :int_title, :uniqueness => true,  :format => /^[a-z0-9_]{0,255}$/, :allow_nil => true
  
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
  
  def position_select
    p = ""
    p += parent_id.to_s unless parent_id.nil?
    p += "_"
    p += position.to_s unless position.nil?
    
    p
  end
  
  def position_select=(position)
    position = position.split("_")
    if position.empty?
      write_attribute("parent_id", nil)
      write_attribute("position", nil)
    else
      write_attribute("parent_id", position.first)
      write_attribute("position", position.last)
    end
  end
end
