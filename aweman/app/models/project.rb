class Project < ActiveRecord::Base
  attr_accessible :name, :description
  
  validates :name, :presence => true, :length => { :maximum => 50 }, :uniqueness => true
  
  has_many :group_projects, :dependent => :destroy
  has_many :groups, :through => :group_projects
end
