class Category < ActiveRecord::Base
  has_many :category_names
  has_many :pages
  
  def initialize(options)
    super()
    
    lang = Language.find_by_short(options[:language])
    lang_id = lang.nil? ? 0 : lang.id
    
    self.category_names.build(:name => options[:name], :language_id => lang_id)
  end
end
