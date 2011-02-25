class NewsController < ApplicationController
  def index
  end
  
  def new
    @title = "create new post"
    @edit_post = Page.new(:page_type => :news, :enabled => false)
    @edit_post.role = Role.find_by_int_name(:guest)
    @edit_post.user = @current_user
    @edit_post.page_contents.build
  end
  
  def create
    @edit_post = Page.new(params[:page].merge(:page_type => :news, :enabled => false, :role => Role.find_by_int_name(:guest), :user => @current_user))
    
    if @edit_post.save
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
  end
  
end
