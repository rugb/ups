module CategoriesHelper
  def category_path(category)
    show_category_path(category, select_by_language_id(category.category_names).name)
  end
  
  def category_name(category)
    select_by_language_id(category.category_names).name
  end
end
