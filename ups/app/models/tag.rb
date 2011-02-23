class Tag < ActiveRecord::Base
  attr_accessible :name
  
  belongs_to :page
  
  validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
end
