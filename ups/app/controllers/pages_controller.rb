require 'pages_helper'

class PagesController < ApplicationController
  def index
    @pages = Page.find :all, :conditions => { :parent_id => nil }
  end
  
  def show
    @page = Page.find_by_id(params[:id])
    
    redirect_to show_page_path(@page.id, @page.int_title) if (params[:int_title] != @page.int_title)
    
    render :action => :home unless @page.enabled
    
    @page_content = select_by_language_id(@page.page_contents)
  end
  
  def new
    @page = Page.new(:page_type => :page, :enabled => false, :int_title => "new")
    @page_content = @page.page_contents.build(:title => "new page")
  end
  
  def edit
  end
  
  def create
    @page = Page.new(params[:page])
    
    if @page.save
      redirect_to edit_page_path(@page)
    else
      render :action => "new"
    end
  end
  
  def destroy
    Page.find_by_id(params[:id]).destroy
    flash[:success] = "page deleted"
    
    redirect_to pages_path
  end
  
  def update
  end
  
  def home
    default_page = Conf.get_default_page
    redirect_to view_context.make_page_path(default_page)
  end
  
  def credits
  end
end
