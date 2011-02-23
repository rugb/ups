class Tag < ActiveRecord::Base
  attr_accessible :name
  
  has_many :page_tags
  has_many :pages, :through => :page_tags
  
  validates :name, :presence => true, :uniqueness => { :case_sensitive => false }
end
