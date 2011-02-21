class Project < ActiveRecord::Base
  attr_accessible :name, :description
  
  validates :name, :presence => true, :length => { :maximum => 50 }, :uniqueness => true
end
