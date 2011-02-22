class Language < ActiveRecord::Base
  attr_accessible :short, :name
  
  validates :short, :presence => true, :length => 2..2
  validates_presence_of :name
end
