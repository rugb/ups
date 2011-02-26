module LinksHelper

  def categories_options
    Category.all.collect { |c| [category_name(c), c.id] }
  end
  
end
