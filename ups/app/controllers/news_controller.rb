class NewsController < ApplicationController
  def index
  end
  
  def new
    @edit_post = Page.new(:type => :news, :enabled => false, :role => :guest, :user => @current_user)
    @edit_post.page_contents.build
  end
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
end
