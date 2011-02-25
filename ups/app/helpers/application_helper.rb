module ApplicationHelper
  def make_title
   (make_page_title or "ups") + " - university project system"
  end
  
  def make_page_title
   (@title or (@page and page_title(@page)))
  end
end
