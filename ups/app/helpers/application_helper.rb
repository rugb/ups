module ApplicationHelper
  def make_title
    @page_content.nil? ? "ups" : @page_content.title
  end
end
