module ApplicationHelper
  def make_title
   (@title or (@page_content and @page_content.title) or "ups") + " - university project system"
  end
end
