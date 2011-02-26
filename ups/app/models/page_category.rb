class PageCategory < ActiveRecord::Base
  attr_accessor :checked, :category_attributes
  
  belongs_to :page
  belongs_to :category
  accepts_nested_attributes_for :category
end
