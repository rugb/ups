class PagesController < ApplicationController
  #before_filter :current_show_page
  filter_access_to :all
  
  include PagesHelper
  
  def index
    @pages = Page.find :all, :conditions => { :parent_id => nil }
  end
  
  def show
    @page = Page.find_by_id(params[:id])
    
    if (!has_role_with_hierarchy?(@page.role.int_name))
      permission_denied
    else
      http_404 and return if(@page.nil? || !@page.visible?)
      
      redirect_to show_page_path(@page.id, @page.int_title) if (params[:int_title] != @page.int_title)
      
      cookies.permanent.signed[:user_language] = params[:language_short] if params[:language_short].present?
      
      redirect_to @page.forced_url if @page.forced_url.present?
    end
  end
  
  def new
    @title = "create new page"
    @edit_page = Page.create!(:page_type => :page, :enabled => false, :role => Role.find_by_int_name(:guest), :user_id => @current_user.id)
    flash[:success] = "page created."
    redirect_to edit_page_path(@edit_page)
  end
  
  def edit
    @title = "edit page"
    @edit_page = Page.find_by_id(params[:id])
    @edit_page_content = select_by_language_id(@edit_page.page_contents)
  end
  
  def destroy
    Page.find_by_id(params[:id]).destroy
    flash[:success] = "page deleted."
    
    redirect_to pages_path
  end
  
  def update
    @edit_page = Page.find(params[:id])
    
    position_select = params[:position_select].split("_")
    
    if position_select.empty?
      @edit_page.parent = nil
      @edit_page.position = nil
    else
      @edit_page.parent = Page.find_by_id(position_select[0])
      @edit_page.position = position_select[1] == "" ? nil : position_select[1].to_i
    end
    
    if @edit_page.save and @edit_page.update_attributes(params[:page])
      recalc_page_positions_for_page(@edit_page)
      flash[:success] = "page updated."
      redirect_to edit_page_path(@edit_page)
    else
      flash[:success] = "page update failed."
      render :action => "edit"
    end
  end
  
  def activate
    @edit_page = Page.find(params[:id])
    @edit_page.enabled = true
    if(@edit_page.save)
      flash[:success] = "activated."
      redirect_to pages_path
    else
      flash[:error] = "this page cannot be activated."
      redirect_to pages_path
    end
  end
  
  def deactivate
    @edit_page = Page.find(params[:id])
    @edit_page.enabled = false
    @edit_page.save
    if(@edit_page.save)
      flash[:success]="deactivated."
      redirect_to pages_path
    else
      flash[:error] = "this page cannot be deactivated."
      redirect_to pages_path
    end
  end
  
  def home
    default_page = Conf.get_default_page
    if default_page.nil?
      redirect_to setup_path
    else
      redirect_to make_page_path(default_page), :flash => flash
    end
  end
  
  def credits
  end
  
  def setup
  end
  
  private
  def current_show_page
    @page ||= Page.find_by_id(params[:id]) if params[:id].present?
  end
  
  def recalc_page_positions_for_page(page)
    pages = Page.find(:all, :conditions => {:parent_id => ((page.parent and page.parent_id) or nil)})
    p "pages", pages.size
    pages.each_with_index do |page, i|
     (page.position = (i+1) * 10) and page.save if page.position.present?
    end
  end
end