class PagesController < ApplicationController
  #before_filter :current_show_page
  filter_access_to :all
  
  include PagesHelper
  
  def index
    @pages = editable_children_pages nil
  end
  
  def show
    @page = Page.find params[:id]
    
    if !has_role_with_hierarchy?(@page.role.int_name)
      permission_denied
    else
      http_404 and return if(@page.nil? || !@page.visible?)
      
      redirect_to show_page_path(@page.id, @page.int_title) and return if (params[:int_title] != @page.int_title)
      set_session_language params[:language_short] if params[:language_short].present?
      
      redirect_to @page.forced_url if @page.forced_url.present?
    end
  end
  
  def new
    @title = "create new page"
    @edit_page = Page.new(:page_type => :page, :enabled => false, :role => Role.find_by_int_name(:guest))
    @edit_page.extend
    @edit_page.user = @current_user
  end
  
  def create
    @title = "create new page"
    @edit_page = Page.new(params[:page].merge(:page_type => :page, :enabled => false, :role => Role.find_by_int_name(:guest), :user => @current_user))
    
    position_select = params[:position_select].split("_")
    
    if position_select.empty?
      @edit_page.parent = nil
      @edit_page.position = nil
    else
      @edit_page.parent = Page.find_by_id position_select[0]
      @edit_page.position = position_select[1] == "" ? nil : position_select[1].to_i
    end
    
    update_edit_role
    
    if @edit_page.valid? && @edit_page.page_contents.any? &&  @edit_page.save
      cache_html!(@edit_page)
      flash[:success] = "page created."
      redirect_to edit_page_path @edit_page
    else
      @edit_page.extend
      flash.now[:error] = "page creation failed."
      render :action => :new
    end
    
  end
  
  def edit
    @title = "edit page"
    @edit_page = Page.find params[:id]
    @edit_page.extend
  end
  
  def destroy
    Page.find(params[:id]).destroy
    flash[:success] = "page deleted."
    
    redirect_to pages_path
  end
  
  def update
    @title = "edit page"
    @edit_page = Page.find params[:id]
    
    position_select = params[:position_select].split("_")
    
    if position_select.empty?
      @edit_page.parent = nil
      @edit_page.position = nil
    else
      @edit_page.parent = Page.find_by_id position_select[0]
      @edit_page.position = position_select[1] == "" ? nil : position_select[1].to_i
    end

    update_edit_role
    
    if @edit_page.update_attributes params[:page].merge(:user => @current_user)
      cache_html! @edit_page 
      recalc_page_positions_for_page @edit_page
      flash.now[:success] = "post updated."
    else
      flash.now[:error] = "post update failed."
    end
    @edit_page.extend
    render :action => :edit
  end
  
  def activate
    @edit_page = Page.find params[:id]
    @edit_page.enabled = true
    if @edit_page.save
      flash[:success] = "activated."
    else
      flash[:error] = "this page cannot be activated."
    end
    
    redirect_to pages_path
  end
  
  def deactivate
    @edit_page = Page.find params[:id]
    @edit_page.enabled = false
    @edit_page.save
    if @edit_page.save
      flash[:success]= "deactivated."
      redirect_to pages_path
    else
      flash[:error] = "this page cannot be deactivated."
      redirect_to pages_path
    end
  end

  def create_comment_preview
    
  end

  def create_comment
    @page = Page.find params[:id]
    @comment = Comment.new(params[:comment])
    @comment.user = @current_user if signed_in?
    @comment.page_id = @page.id

    @comment.save!

    flash[:success] = "comment created"
    if @page.page_type == :page
      redirect_to make_page_path @page
    else
      redirect_to show_news_path @page
    end
  end

  def destroy_comment
    @page = Page.find params[:id]
    @comment = Comment.find params[:comment_id]

    @comment.destroy

    flash[:success] = "comment deleted"
    
    if @page.page_type == :page
      redirect_to make_page_path @page
    else
      redirect_to show_news_path @page
    end
  end
  
  def home
    default_page = Conf.default_page
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
  def update_edit_role
    @edit_page.edit_role_id = @current_user.role.id

    if has_role_with_hierarchy?(:admin) && params[:page][:edit_role_id].present?
      @edit_page.edit_role_id = params[:page][:edit_role_id]
    end

  end

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