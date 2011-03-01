module CategoriesHelper
  def category_name(category)
    select_by_language_id(category.category_names).name
  end
end
