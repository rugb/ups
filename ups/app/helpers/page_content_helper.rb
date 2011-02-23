module PageContentHelper
  def page_content_path(page_content)
    update_page_content_page_path(@page.id, @language.id)
  end
  
  def page_contents_path
    create_page_content_page_path(@page.id, @language.id)
  end
end
