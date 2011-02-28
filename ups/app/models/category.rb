# == Schema Information
# Schema version: 20110225155059
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  has_many :category_names, :dependent => :destroy
  accepts_nested_attributes_for :category_names
  
  has_many :page_categories
  has_many :pages, :through => :page_categories
  
  has_many :link_categories
  has_many :links, :through => :link_categories
  
  validate do |category|
    category.errors.add :category, "should have a name" if category.category_names.empty?
  end
  
  before_validation :check_category_names
  before_destroy :deletable?
  
  def deletable?
    pages.empty? && links.empty?
  end
  
  def self.get_or_new(options)
    if (!options[:id].nil?)
      return Category.find(options[:id])
    else
      return Category.new(options)
    end
  end
  
  private
  def check_category_names
    category_names.reject! { |cn| !cn.valid? }
  end
end
