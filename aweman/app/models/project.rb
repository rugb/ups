class Project < ActiveRecord::Base
  attr_accessible :name, :description
  
  validates :name, :presence => true, :length => { :maximum => 50 }, :uniqueness => true
  
  has_many :group_projects, :dependent => :destroy
  has_many :groups, :through => :group_projects
  
  def has_group?(group)
    group_projects.find_by_group_id(group)
  end
  
  def add_group!(group)
    group_projects.create!(:group_id => group.id)
  end
end
