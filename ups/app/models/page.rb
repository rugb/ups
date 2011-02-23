class Page < ActiveRecord::Base
  attr_accessible :parent_id, :page_type, :enabled, :position, :int_title, :forced_url
  
  belongs_to :parent, :class_name => "Page", :foreign_key => "parent_id"
  has_many :children, :class_name => "Page", :foreign_key => "parent_id", :dependent => :destroy
  
  has_many :page_contents, :dependent => :destroy
  has_many :tags
  
  has_many :page_categories, :dependent => :destroy
  has_many :categories, :through => :page_categories
  
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
    read_attribute("page_type").to_sym
  end
  
  def page_type=(type)
    write_attribute("page_type", type.to_s)
  end
  
  def position_select
    p = ""
    p = parent_id unless parent_id.nil?
    p += "_"
    p += position unless position.nil?
  end
end
