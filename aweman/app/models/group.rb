class Group < ActiveRecord::Base
  attr_accessible :nr
  
  validates :nr, :uniqueness => true
  validates_numericality_of :nr, :greater_than => 0, :only_integer => true, :message => "must be greater than 0"
  
  has_many :users
  has_many :group_projects, :dependent => :destroy
  has_many :projects, :through => :group_projects
  
  def has_project?(project)
    group_projects.find_by_project_id(project)
  end
  
  def add_project!(project)
    group_projects.create!(:project_id => project.id)
  end
  
  def remove_project!(project)
    group_projects.find_by_project_id(project).destroy
  end
end
