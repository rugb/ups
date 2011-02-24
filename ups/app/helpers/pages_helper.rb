module PagesHelper
  def make_page_path(page)
    if page.forced_url.nil?
      if(page.int_title.nil?)
        page_path(page)
      else
        show_page_path(page.id, page.int_title)
      end
    else
      page.forced_url
    end
  end
  
  def get_page_contents_by_all_languages(page)
    page_contents = {}
    Language.all.each do |language|
      page_contents[language] = page.page_contents.find :first, :conditions => { :language_id => language.id }
    end
    
    page_contents
  end
  
  def possible_page_position_options(page)
    make_page_position_tree(nil, page)
  end
  
  def make_page_title(page)
    page_content = select_by_language_id(page.page_contents)
    if page_content.nil?
      page.int_title or "new"
    else
      page_content.title + " parent:" + page.parent_id.to_s + ", pos:" + page.position.to_s
    end
  end
  
  private
  def make_page_position_tree(parent, me)
    options = []
    
    if(parent.nil?)
      pages = Page.find :all, :conditions => { :parent_id => nil }
      options << radio_button_tag(:position_select, "_") + " not in menu"
      options << radio_button_tag(:position_select, "_1") + " first"
    else
      pages = parent.children
      options << radio_button_tag(:position_select, parent.id.to_s+"_1") + " under " + make_page_title(parent)
    end
    
    pages.each do |page|
      if(page == me)
        options << radio_button_tag(:position_select, page.position_select, true) + " " + make_page_title(page)
      elsif(page.position.present?)
        options << " " + make_page_title(page) + make_page_position_tree(page, me)
        options << radio_button_tag(:position_select, page.parent_id.to_s + "_" + (page.position + 1).to_s)
      end
    end
    
    make_html_list(options)
  end
  
  def make_html_list(array)
    return "" if array.empty?
    raw "<ul>" + array.map { |e| "<li>" + e + "</li>" }.join + "</ul>"
  end
end
