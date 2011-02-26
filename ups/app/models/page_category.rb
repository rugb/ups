# == Schema Information
# Schema version: 20110225155059
#
# Table name: page_categories
#
#  id          :integer         not null, primary key
#  page_id     :integer
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class PageCategory < ActiveRecord::Base
  attr_accessor :checked, :category_attributes
  
  belongs_to :category
  belongs_to :page
  
  accepts_nested_attributes_for :category
end
