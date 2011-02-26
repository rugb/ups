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
    @edit_post.page_contents.build
    Category.all.each do |cat|
      @edit_post.page_categories.build(:category_id => cat.id)
    end
  end
  
  def create
    @edit_post = Page.new(params[:page].merge(:page_type => :news, :enabled => false, :role => Role.find_by_int_name(:guest), :user => @current_user))
    
    if @edit_post.save
      @edit_post.reload
      @edit_post.parent = Page.find(:first, :conditions => {:forced_url => "/news"})
      @edit_post.user = @current_user
      @edit_post.enabled = true
      @edit_post.save
      p "post", @edit_post
      p "errors", @edit_post.errors
      flash[:success] = "post created."
      redirect_to edit_news_path @edit_post
    else
      flash[:error] = "post creation failed."
      render :action => :new
    end
  end
  
  def edit
    @title = "edit post"
  end
  
  def update
  end
  
  def destroy
    @edit_news = Page.find(params[:id])
    @edit_news.destroy
    
    flash[:success] = "post deleted."
    redirect_to news_index_path
  end
  
  def rss
    @news = Page.find(:all, :order => "created_at DESC", :conditions => {:page_type => :news}, :limit => 10)
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
  
  private
  
  def load_news
    @edit_news = Page.find(params[:id]) if params[:id].present?
  end
  
end
