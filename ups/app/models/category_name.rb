# == Schema Information
# Schema version: 20110225155059
#
# Table name: category_names
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  language_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  category_id :integer
#

class CategoryName < ActiveRecord::Base
  attr_accessible :name, :language_id, :category_id

  belongs_to :category
  belongs_to :language

  validates :name, :presence => true, :uniqueness => true, :length => { :maximum => 255 }
  validates :language_id, :presence => true
  validates_numericality_of :language_id, :greater_than => 0

  default_scope :order => "category_names.language_id"
end
