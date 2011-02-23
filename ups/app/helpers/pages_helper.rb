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
  
  def possible_page_positions_options
    [["not in menu", "_"], ["first", "_1"]]
  end
end
