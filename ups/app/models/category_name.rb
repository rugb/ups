class CategoryName < ActiveRecord::Base
  attr_accessible :name, :language_id, :category_id
  
  belongs_to :category
  belongs_to :language
  
  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 255 }
end
