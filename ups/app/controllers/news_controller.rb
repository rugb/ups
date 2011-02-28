class NewsController < ApplicationController
  before_filter :load_news
  
  filter_access_to :edit, :update, :attribute_check => true, :model => Page
  
  filter_access_to :all
  
  def show
    @news = Page.find(params[:id])
    @title = view_context.page_title(@news)
  end
  
  def index
    @news = Page.find(:all, :order => "created_at DESC", :conditions => {:page_type => :news})
  end
  
  def new
    @title = "create new post"
    @edit_post = Page.new(:page_type => :news, :enabled => false)
    @edit_post.role = Role.find_by_int_name(:guest)
    @edit_post.user = @current_user
    @edit_post.page_contents.build(:language_id => wanted_languages.first.id)
    extend_page_categories(@edit_post)
  end
  
  def create
    @edit_post = Page.new(params[:page].merge(:page_type => :news, :enabled => false, :role => Role.find_by_int_name(:guest), :user => @current_user))
    
    if @edit_post.save
      @edit_post.reload
      @edit_post.parent = Page.find(:first, :conditions => {:forced_url => "/news"})
      @edit_post.user = @current_user
      @edit_post.enabled = true
      @edit_post.save
      flash[:success] = "post created."
      redirect_to edit_news_path @edit_post
    else
      flash[:error] = "post creation failed."
      render :action => :new
    end
  end
  
  def edit
    @title = "edit post"
    @edit_post = Page.find params[:id] 
    extend_page_contents(@edit_post)
  end
  
  def update
    @edit_post = Page.find params[:id]
    
    if @edit_post.update_attributes(params[:page])
      flash[:success] = "post updated."
    else
      flash[:error] = "post update failed."
    end
    extend_page_contents(@edit_post)
    render :action => :edit
  end
  
  def destroy
    @edit_post = Page.find(params[:id])
    @edit_post.destroy
    
    flash[:success] = "post deleted."
    redirect_to news_index_path
  end
  
  def rss
    @news = Page.find(:all, :order => "created_at DESC", :conditions => {:page_type => :news}, :limit => 10)
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
  
  private
  
  def extend_page_contents(page)
    Language.all.each do |lang|
      found = false
      page.page_contents.each do |page_content|
        found ||= lang == page_content.language
      end
      page.page_contents.build(:language_id => lang.id) unless found
    end
  end
  
  def extend_page_categories(page)
    Category.all.each do |cat|
      found = false
      page.page_categories.each do |page_category|
        found ||= cat == page_category.category
        page_category.checked = "1"
      end
      page_category = page.page_categories.build
      page_category.category = cat
    end
  end
  
  def load_news
    @edit_news = Page.find(params[:id]) if params[:id].present?
  end
  
end
