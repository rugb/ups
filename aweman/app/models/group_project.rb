class GroupProject < ActiveRecord::Base
  attr_accessible :project_id, :group_id
  
  belongs_to :group
  belongs_to :project
  
  validates :group, :presence => true
  validates :project, :presence => true
end
