class Link < ActiveRecord::Base
  has_many :link_categories
  has_many :categories, :through => :link_categories
  
  validates :title, :presence => true, :length => { :maximum => 255 }
  validates :href, :presence => true, :length => { :maximum => 255 }, :format => /^(http|https|ftp):\/\//
end
