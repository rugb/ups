require 'pp'

class PagesController < ApplicationController
  before_filter :load_page

  #before_filter :load_comment, :only => [ :update_comment, :delete_comment ]
  filter_access_to :edit_comment, :update_comment, :destroy_comment, :model => Comment, :load_method => :load_comment, :attribute_check => true
  filter_access_to :all
  
  include PagesHelper
  include ConfHelper

  def my_logger
    @@log_file = File.open("#{RAILS_ROOT}/log/my.log", File::WRONLY | File::APPEND)
    @@my_logger ||= Logger.new(@@log_file)
  end
  
  
  def index
    @pages = editable_children_pages nil
  end

  def index_news
    if params[:category].present?
      @browse_category = Category.find_by_id params[:category]
    end
    
    if params[:tags].present?
      @browse_tags_names = params[:tags].split "+"
      @browse_tags = @browse_tags_names.map do |tag_name|
        Tag.find_by_name tag_name
      end.compact
    end
    
    @pages = Page.find(:all, :order => "created_at DESC", :conditions => {:page_type => path_type}).find_all do |page|
      (@browse_category.nil? || page.categories.index(@browse_category)) && (page.tags & @browse_tags).size == @browse_tags.size
    end
  end
  
  def show
     if path_type == :news
       render 'show_news'
       return
     end
    
#    if !has_role_with_hierarchy?(@page.role.int_name)
#      permission_denied
#    else
      http_404 and return if(@page.nil? || !@page.visible?)
      
      redirect_to show_page_path(@page.id, @page.int_title) and return if (params[:int_title] != @page.int_title)
      set_session_language params[:language_short] if params[:language_short].present?
      
      redirect_to @page.forced_url if @page.forced_url.present?
#    end
  end
  
  def new
    @title = "create new page"
    @edit_page = Page.new(:page_type => path_type, :enabled => false, :role => Role.find_by_int_name(:guest))
    @edit_page.extend
    @edit_page.user = @current_user
  end
  
  def new_news
    @title = "create new post"
    @edit_page = Page.new(:page_type => path_type, :enabled => false, :role => Role.find_by_int_name(:guest))
    @edit_page.extend
    @edit_page.user = @current_user
  end
  
  def create
    @title = "create new page"
    @edit_page = Page.new(params[:page].merge(:page_type => path_type, :enabled => false, :role => Role.find_by_int_name(:guest), :user => @current_user))
    
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

  def create_news
    @title = "create new post"
    @edit_page = Page.new(params[:page].merge(:page_type => path_type, :enabled => false, :role => Role.find_by_int_name(:guest), :user => @current_user))
    @edit_page.edit_role = Role.find_by_int_name :member
    
    if @edit_page.valid? && @edit_page.page_contents.any? &&  @edit_page.save
      cache_html!(@edit_page)
      
      @edit_page.reload
      @edit_page.parent = Page.find(:first, :conditions => {:forced_url => "/news"})
      @edit_page.enabled = true
      @edit_page.save
      twitter_update(make_page_url(@edit_page) + ": " + select_by_languages(@edit_page.page_contents, [Conf.default_language]).title)
      flash[:success] = "post created."
      redirect_to edit_news_path @edit_page
    else
      @edit_page.extend
      flash.now[:error] = "post creation failed."
      render :action => :new_news
    end
  end
  
  def edit
    @title = "edit page"
    @edit_page = Page.find params[:id]
    @edit_page.extend
  end

  def edit_news
    @title = "edit #{path_type.to_s}"
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

  def update_news
    @title = "edit #{path_type.to_s}"
    @edit_page = Page.find params[:id]
    
    if @edit_page.update_attributes(params[:page].merge(:page_type => :news, :role => Role.find_by_int_name(:guest)))
      cache_html!(@edit_page)
      flash.now[:success] = "post updated."
    else
      flash.now[:error] = "post update failed."
    end
    @edit_page.extend
    render :action => :edit_news
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

    if @comment.save
      flash[:success] = "comment created"
    else
      flash[:error] = "comment not created"
    end
    if @page.page_type == :page
      redirect_to make_page_path @page
    else
      redirect_to show_news_path @page
    end
  end

  def edit_comment
     @comment = Comment.find params[:comment_id]
  end

  def update_comment
    @page = Page.find params[:id]
    @comment = Comment.find params[:comment_id]

    if @comment.update_attributes(params[:comment])
      flash[:success] = "comment updated"

      if @page.page_type == :page
        redirect_to make_page_path @page
      else
        redirect_to show_news_path @page
      end      
    else
      flash.now[:error] = "error on updating a comment"
      render :edit_comment
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

  def rss
    @news = Page.find(:all, :order => "created_at DESC", :conditions => {:page_type => path_type}, :limit => 10)
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
  
  private
  def update_edit_role
    if @edit_page.edit_role.present?
      @edit_page.edit_role_id = @current_user.role.id

      if has_role_with_hierarchy?(:admin) && params[:page][:edit_role_id].present?
        @edit_page.edit_role_id = params[:page][:edit_role_id]
      end
    end
  end

  def path_type
    return :page if /^\/pages/ =~ request.request_uri
    return :news if /^\/news/ =~ request.request_uri
    return :news if /^\/blog/ =~ request.request_uri
  end
  
  def load_page
    @page = Page.find_by_id(params[:id]) if params[:id].present?

    @browse_tags = []
  end

  def load_comment
    @comment = Comment.find params[:comment_id]
  end
  
  def recalc_page_positions_for_page(page)
    pages = Page.find(:all, :conditions => {:parent_id => ((page.parent and page.parent_id) or nil)})
    p "pages", pages.size
    pages.each_with_index do |page, i|
     (page.position = (i+1) * 10) and page.save if page.position.present?
    end
  end
end