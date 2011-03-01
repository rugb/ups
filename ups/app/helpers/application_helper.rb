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
    }.map { |cat| link_to category_name(cat), browse_news_path(cat) })
  end
  
  def list_categories_for(page)
    make_html_list(page.categories.sort { |a, b|
      select_by_language_id(a.category_names).name <=> select_by_language_id(b.category_names).name
    }.map { |cat| link_to category_name(cat), browse_news_path(cat) })
  end
  
  def inline_categories_for(page)
    raw page.categories.sort { |a, b|
      select_by_language_id(a.category_names).name <=> select_by_language_id(b.category_names).name
    }.map { |cat| link_to category_name(cat), browse_news_path(cat) }.join(", ")
  end

  def list_tags_for(page)
    make_html_list(page.tags.map { |tag| link_to tag.name, browse_news_path(nil, [tag]) })
  end

  def tag_cloud
    raw(Tag.all.map do |tag|
      link_to tag.name, browse_news_path(nil, [tag]), :style => calc_tag_style(tag.pages.size)
    end.join ", ")
  end
  
  def inline_tags_for(page)
    raw(page.tags.map do |tag|
      link_to tag.name, browse_news_path(nil, [tag])
    end.join ", ")
  end

  def make_html_list(array)
    return "" if array.empty?
    raw "<ul>" + array.map { |e| "<li>" + e + "</li>" }.join + "</ul>"
  end

  private

  def calc_tag_style(size)
    "font-size: " + (Math.log(size, 10) + 0.7).round(1).to_s + "em;"
  end
end
