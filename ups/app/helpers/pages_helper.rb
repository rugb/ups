module PagesHelper
  def make_page_path(page)
    page.forced_url.nil? ? show_page_path(page.id, page.int_title) : page.forced_url 
  end
  
  def get_page_contents_by_all_languages(page)
    Languages.all.each do |language|
      page_contents[language] = page.page_contents.find { |page_content| page_content.language == language }
    end
    
    page_contents
  end
  
  def possible_page_positions_options(page)
    options = [["not in menu", "_"], ["first", "_1"]]
    root_pages = Page.find :all, :conditions => { :parent_id => nil }
    root_pages.each do |root_page|
      make_page_position_tree(root_page, options, me)
    end
    
    options
  end
  
  private
  def make_page_position_tree(page, options, me)
    if(page == me)
      options.push [page.int_title, page.position_select]
    else
      options.push ["after " + page.int_title, page.position_select]
      options.push ["under " + page.int_title, page.id + "_1"]
      page.children.each { |child| make_page_position_tree(child, options, me) }
    end
  end
end
