class NewsController < ApplicationController
  before_filter :load_news
  
  filter_access_to :edit, :update, :attribute_check => true, :model => Page
  
  filter_access_to :all
  
  def show
    @page = Page.find(params[:id])
  end
  
  def index
    @news = Page.find(:all, :order => "created_at DESC", :conditions => {:page_type => :news})
  end
  
  def new
    @title = "create new post"
    @edit_post = Page.new(:page_type => :news, :enabled => false, :role => Role.find_by_int_name(:guest))
    @edit_post.extend
    @edit_post.user = @current_user
  end
  
  def create
    @title = "create new post"
    @edit_post = Page.new(params[:page].merge(:page_type => :news, :enabled => false, :role => Role.find_by_int_name(:guest)))
    
    if @edit_post.page_contents.any? &&  @edit_post.save
      @edit_post.reload
      @edit_post.parent = Page.find(:first, :conditions => {:forced_url => "/news"})
      @edit_post.user = @current_user
      @edit_post.enabled = true
      @edit_post.save
      flash[:success] = "post created."
      redirect_to edit_news_path @edit_post
    else
      @edit_post.extend
      flash.now[:error] = "post creation failed."
      render :action => :new
    end
  end
  
  def edit
    @title = "edit post"
    @edit_post = Page.find params[:id] 
    @edit_post.extend
  end
  
  def update
    @title = "edit post"
    @edit_post = Page.find params[:id]
    
    if @edit_post.update_attributes(params[:page])
      flash.now[:success] = "post updated."
    else
      flash.now[:error] = "post update failed."
    end
    @edit_post.extend
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
  
  def load_news
    @edit_news = Page.find(params[:id]) if params[:id].present?
  end
end
