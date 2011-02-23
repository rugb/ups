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
      page_contents[language] = page.page_contents.find :all, :conditions => { :language_id => language.id }
    end
    
    page_contents
  end
  
  def possible_page_positions_options(page)
    options = [["not in menu", "_"], ["first", "_1"]]
    root_pages = Page.find :all, :conditions => { :parent_id => nil }
    root_pages.each do |root_page|
      make_page_position_tree(root_page, options, page)
    end
    
    options
  end
  
  private
  def make_page_position_tree(page, options, me)
    if(page == me)
      options.push [(page.int_title or "(new)"), page.position_select]
    else
      options.push ["after " + (page.int_title or "(new)"), page.position_select]
      options.push ["under " + (page.int_title or "(new)"), page.id.to_s + "_1"]
      page.children.each { |child| make_page_position_tree(child, options, me) }
    end
  end
end
