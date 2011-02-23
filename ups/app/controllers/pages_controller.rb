require 'pages_helper'

class PagesController < ApplicationController
  def index
    @pages = Page.find :all, :conditions => { :parent_id => nil }
  end
  
  def show
    @page = Page.find_by_id(params[:id])
    redirect_to show_page_path(@page.id, @page.int_title) if(params[:int_title] != @page.int_title)
    
    @page_content = select_by_language_id(@page.page_contents)
  end
  
  def new
  end
  
  def edit
  end
  
  def create
  end
  
  def destroy
  end
  
  def update
  end
  
  def home
    default_page = Conf.get_default_page
    redirect_to make_page_path(default_page)
  end
  
  def credits
  end
end
