module ApplicationHelper
  def make_title
   ((make_page_title and make_page_title + " - ") or "") + Conf.get_web_name
  end
  
  def make_page_title
   (@title or (@page and page_title(@page)))
  end
  
  def list_categories
    make_html_list(Category.all.sort { |a, b|
      select_by_language_id(a.category_names).name <=> select_by_language_id(b.category_names).name
    }.map { |cat| link_to category_name(cat), category_path(cat) })
  end
  
  def make_html_list(array)
    return "" if array.empty?
    raw "<ul>" + array.map { |e| "<li>" + e + "</li>" }.join + "</ul>"
  end
end
