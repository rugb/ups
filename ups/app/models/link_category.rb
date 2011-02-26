# == Schema Information
# Schema version: 20110225155059
#
# Table name: link_categories
#
#  id          :integer         not null, primary key
#  link_id     :integer
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class LinkCategory < ActiveRecord::Base
  attr_accessor :checked, :category_attributes
  
  belongs_to :category
  belongs_to :link

  accepts_nested_attributes_for :category
end
