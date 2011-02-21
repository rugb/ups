class Group < ActiveRecord::Base
  attr_accessible :nr
  
  validates :nr, :uniqueness => true
  validates_numericality_of :nr, :greater_than => 0, :only_integer => true, :message => "must be greater than 0"
  
  has_many :group_projects, :dependent => :destroy
  has_many :projects, :through => :group_projects
end
