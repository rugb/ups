module ApplicationHelper
  def make_title
   (make_page_title or "ups") + " - university project system"
  end
  
  def make_page_title
   (@title or (@page and page_title(@page)))
  end

  def user_links
    link_to_unless signed_in?, "login", session_login_path do
      link_to "logout", session_logout_path if signed_in?
    end
  end
end
