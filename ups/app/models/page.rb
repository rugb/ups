class Page < ActiveRecord::Base
  has_many :page_contents
  
  validate do |record|
    record.errors.add :parent_id, "cannot have itself as parent" if !record.parent_id.nil? && record.parent_id == record.id
  end
end
