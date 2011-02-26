# == Schema Information
# Schema version: 20110225155059
#
# Table name: links
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  href        :string(255)
#  category_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Link < ActiveRecord::Base
  attr_accessible :title, :href, :category_id, :link_categories_attributes
  
  has_many :link_categories
  has_many :categories, :through => :link_categories
  accepts_nested_attributes_for :link_categories, :reject_if => proc { |attrs| attrs['checked'] == "0" }
  
  
  validates :title, :presence => true, :length => { :maximum => 255 }
  validates :href, :presence => true, :length => { :maximum => 255 }, :format => /^(http|https|ftp):\/\//
  
  def add_category(category)
    self.categories.push(category)
  end
  
  def remove_category(category)
    self.categories.delete(category)
  end
end
