module ApplicationHelper
  def make_title
   (@title or (@page_content and @page_content.title) or "ups") + " - university project system"
  end

  def user_links
    link_to_unless signed_in?, "login", session_login_path do
      link_to "logout", session_logout_path if signed_in?
    end
  end
end
