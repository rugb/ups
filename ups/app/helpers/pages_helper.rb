module PagesHelper

  def editable_children_pages(page)
    page = Page if page.nil?
    page.find(:all, :conditions => {:edit_role_id => @current_user.role.id}).select do |child| 
      child.page_type != :news && has_role_with_hierarchy?(child.edit_role.int_name)
    end
  end

  def visible_children_pages(page)
    Page.find(:all, :conditions => {:enabled => true, :parent_id => (page and page.id)}).find_all do |child|
      child.visible? && child.position.present? && has_role_with_hierarchy?(child.role.int_name) && child.page_type != :news
    end
  end
  
  # thats for the index table of page management
  def make_treecell_style(depth)
    raw('style="background-position: ' + (-48 + 16 * depth).to_s + 'px 0; padding-left: ' + (5 + 16 * depth).to_s + 'px;"')
  end
  
  def page_title(page)
    select_by_language_id(page.page_contents).title
  end
  
  def page_excerpt(page)
    select_by_language_id(page.page_contents).excerpt
  end
  
  def page_text(page)
    raw select_by_language_id(page.page_contents).html
  end
  
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
  
  def make_page_url(page)
    if page.forced_url.nil?
      if(page.int_title.nil?)
        page_url(page)
      else
        show_page_url(page.id, page.int_title)
      end
    else
      root_path + page.forced_url
    end
  end
  
  def possible_page_position_options(page)
    make_page_position_tree(nil, page)
  end
  
  def make_page_int_title(page)
    page_content = select_by_language_id(page.page_contents)
    if page_content.nil?
      page.int_title or "new"
    else
      page_content.title
    end
  end
  
  def roles_options
    Role.all.collect { |r| [ r.to_s.pluralize, r.id ] }
  end
  
  private
  def make_page_position_tree(parent, me)
    options = []
    
    if(parent.nil?)
      pages = Page.find :all, :conditions => { :parent_id => nil }
      options << radio_button_tag(:position_select, "_", me.parent.nil? && me.position.nil?) + " not in menu"
      options << radio_button_tag(:position_select, "_1") + " first"
    else
      pages = parent.children
      options << radio_button_tag(:position_select, parent.id.to_s+"_1") + " under " + make_page_int_title(parent)
    end
    
    pages.each do |page|
      if page.position.present?
        if page == me 
          options << radio_button_tag(:position_select, page.position_select, true) + " " + make_page_int_title(page)
        else
          options << " " + make_page_int_title(page) + make_page_position_tree(page, me)
          options << radio_button_tag(:position_select, page.parent_id.to_s + "_" + (page.position + 1).to_s) + " after " + make_page_int_title(page)
        end
      end
    end
    
    make_html_list(options)
  end
end
