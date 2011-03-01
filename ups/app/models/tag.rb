# == Schema Information
# Schema version: 20110225155059
#
# Table name: tags
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tag < ActiveRecord::Base
  attr_accessible :name
  
  has_many :page_tags
  has_many :pages, :through => :page_tags
  
  validates :name, :presence => true, :uniqueness => { :case_sensitive => false }

  default_scope :order => "name"
end
