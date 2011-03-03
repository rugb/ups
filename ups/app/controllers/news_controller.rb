class NewsController < ApplicationController
  before_filter :load_news
  
  filter_access_to :edit, :update, :attribute_check => true, :model => Page
  
  filter_access_to :all
  
  include PagesHelper
  include ConfHelper
  
  def show
    @page = Page.find(params[:id])
  end
  
  def index
    if params[:category].present?
      @browse_category = Category.find_by_id params[:category]
    end

    if params[:tags].present?
      @browse_tags_names = params[:tags].split "+"
      @browse_tags = @browse_tags_names.map do |tag_name|
        Tag.find_by_name tag_name
      end.compact
    end

    @news = Page.find(:all, :order => "created_at DESC", :conditions => {:page_type => :news}).find_all do |page|
      (@browse_category.nil? || page.categories.index(@browse_category)) && (page.tags & @browse_tags).size == @browse_tags.size
    end
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
    @edit_post.edit_role = Role.find_by_int_name :member

    if @edit_post.valid? && @edit_post.page_contents.any? &&  @edit_post.save  
      cache_html!(@edit_post)

      @edit_post.reload
      @edit_post.parent = Page.find(:first, :conditions => {:forced_url => "/news"})
      @edit_post.user = @current_user
      @edit_post.enabled = true
      @edit_post.save
      twitter_update(make_page_url(@edit_post) + ": " + select_by_languages(@edit_post.page_contents, [Conf.default_language]).title)
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
    
    if @edit_post.update_attributes(params[:page].merge(:page_type => :news, :role => Role.find_by_int_name(:guest)))
      cache_html!(@edit_post)
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

    Tag.all.each do |tag|
      tag.destroy if tag.pages.empty?
    end
    
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
    @browse_tags = []
  end
end
