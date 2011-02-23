class CategoryName < ActiveRecord::Base
  belongs_to :category
  belongs_to :language
  
  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 255 }
  validates_numericality_of :language_id, :presence => true, :greater_than => 0
end
