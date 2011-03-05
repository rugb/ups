module PagesHelper
  def page_visible?(page)
    page.visible?
  end

  def page_activateable?(page)
    page.activateable? && permitted_to?(:activate, page)
  end

  def page_deactivateable?(page)
    page.deactivateable? && permitted_to?(:deactivate, page)
  end

  def page_editable?(page)
    if page.edit_role.nil?
      has_role_with_hierarchy? :admin
    else
      has_role_with_hierarchy?(page.edit_role.int_name)
    end
  end

  def page_edit_role_changeable?(page)
    has_role_with_hierarchy? :admin
  end

  def page_deleteable?(page)
    page.deleteable?
  end

  def editable_children_pages(page)
    if page.nil?
      Page.find(:all).select do |child|
        child_editable?(child) && (child.parent.nil? || (child.parent.edit_role.present? && !has_role_with_hierarchy?(child.parent.edit_role.int_name)))
      end
    else
      page.children.find(:all, :conditions => {:parent_id => page.id}).select do |child|
        child_editable?(child)
      end
    end
  end

  def visible_children_pages(page)
    children_pages(page).find_all do |child|
      child.visible?
    end
  end

  def children_pages(page)
    Page.find(:all, :conditions => {:parent_id => (page and page.id)}).find_all do |child|
      child.position.present? && has_role_with_hierarchy?(child.role.int_name) && child.page_type != :news
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
    unless page.forced_url?
      unless page.int_title?
        page_path(page)
      else
        show_page_path(page.id, page.int_title)
      end
    else
      page.forced_url
    end
  end

  def make_page_url(page)
    unless page.forced_url?
      unless page.int_title?
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

  def edit_roles_options
    admin = Role.find_by_int_name :admin
    member = Role.find_by_int_name :member
    [[admin.to_s.pluralize, admin.id], [member.to_s.pluralize, member.id]]
  end

  private
  def make_page_position_tree(parent, me)
    options = []

    if(parent.nil?)
      pages = children_pages nil
      options << radio_button_tag(:position_select, "_", me.parent.nil? && me.position.nil?) + " not in menu"
      options << radio_button_tag(:position_select, "_1") + " first"
    else
      pages = children_pages parent
      options << radio_button_tag(:position_select, parent.id.to_s+"_1") + " under " + make_page_int_title(parent)
    end

    pages.each do |page|
      if page.position?
        p page, me
        if page.id == me.id
          options << radio_button_tag(:position_select, page.position_select, true) + " " + make_page_int_title(page)
        else
          options << " " + make_page_int_title(page) + make_page_position_tree(page, me)
          options << radio_button_tag(:position_select, page.parent_id.to_s + "_" + (page.position + 1).to_s) + " after " + make_page_int_title(page)
        end
      end
    end

    make_html_list(options)
  end

  def child_editable?(child)
    if child.edit_role.nil?
      has_role_with_hierarchy? :admin
    else
      child.page_type != :news && has_role_with_hierarchy?(child.edit_role.int_name)
    end
  end
end
