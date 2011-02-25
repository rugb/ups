class Category < ActiveRecord::Base
  has_many :category_names, :dependent => :destroy
  
  has_many :page_categories
  has_many :pages, :through => :page_categories
  
  has_many :link_categories
  has_many :links, :through => :link_categories
  
  before_validation :check_category_names
  before_destroy :deletable?
  
  #def initialize(options)
  #super()
  
  #lang = Language.find_by_any(options[:language])
  #lang_id = lang.nil? ? 0 : lang.id
  
  #self.category_names.build(:name => options[:name], :language_id => lang_id)
  #end
  
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
  
  def category_names_attributes=(attributes)
    p "aha", attributes
  end
  
  private
  def check_category_names
    category_names.reject! { |cn| !cn.valid? }
  end
end
