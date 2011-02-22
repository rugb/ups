class Page < ActiveRecord::Base
  has_many :page_contents
  
  validate do |record|
    record.errors.add :parent_id, "cannot have itself as parent" if !record.parent_id.nil? && record.parent_id == record.id
  end
  validates_numericality_of :position, :only_integer => true, :greater_than => 0, :allow_nil => 0
end
