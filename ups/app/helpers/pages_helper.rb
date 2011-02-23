module PagesHelper
  def page_path(page)
    page.forced_url.nil? ? show_page_path(page.id, page.int_title) : page.forced_url 
  end
end
