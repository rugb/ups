class Page < ActiveRecord::Base
  attr_accessible :type, :enabled, :position, :int_title
  
  has_many :page_contents
  
  validate do |record|
    # reject pages having itself as parent
    record.errors.add :parent_id, "cannot have itself as parent" if !record.parent_id.nil? && record.parent_id == record.id
    
    # page cannot be enabled without int_title
    record.errors.add :enabled, "connot be true if page has no internal title" if record.enabled && (record.int_title.nil? || record.int_title == "")
  end
  validates_numericality_of :position, :only_integer => true, :greater_than => 0, :allow_nil => true
  validates_inclusion_of :type, :in => [:news, :page]
  validates_inclusion_of :enabled, :in => [true, false]
  validates_format_of :int_title, :with => /^[a-z_]{0,255}$/
end
