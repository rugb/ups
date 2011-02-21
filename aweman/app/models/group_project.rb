class GroupProject < ActiveRecord::Base
  belongs_to :group
  belongs_to :project
  
  validates :group, :presence => true
  validates :project, :presence => true
end
