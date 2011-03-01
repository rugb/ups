module ApplicationHelper
  
  # generates title für <title> tag
  def make_title
    title = make_page_title + " - " if make_page_title.present?
    title.to_s + Conf.web_name
  end
  
  # finds page title that might be good for actual page
  def make_page_title
    return @title if @title.present?
    return page_title(@page) if @page.present?
  end
  
  def list_categories
    make_html_list(Category.all.sort { |a, b|
      select_by_language_id(a.category_names).name <=> select_by_language_id(b.category_names).name
    }.map { |cat| link_to category_name(cat), category_path(cat) })
  end
  
  def list_categories_for(page)
    make_html_list(page.categories.sort { |a, b|
      select_by_language_id(a.category_names).name <=> select_by_language_id(b.category_names).name
    }.map { |cat| link_to category_name(cat), category_path(cat) })
  end
  
  def inline_categories_for(page)
    raw page.categories.sort { |a, b|
      select_by_language_id(a.category_names).name <=> select_by_language_id(b.category_names).name
    }.map { |cat| link_to category_name(cat), category_path(cat) }.join(", ")
  end

  def list_tags_for(page)
    make_html_list(page.tags.sort { |a, b|
      a.name <=> b.name
      }.map { |tag| link_to tag.name, "" })
  end
  
  def make_html_list(array)
    return "" if array.empty?
    raw "<ul>" + array.map { |e| "<li>" + e + "</li>" }.join + "</ul>"
  end
end
