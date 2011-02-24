class PagesController < ApplicationController
  def index
    @pages = Page.find :all, :conditions => { :parent_id => nil }
  end
  
  def show
    @page = Page.find_by_id(params[:id])
    
    if(@page.nil? || !@page.visible?)
      http_404
    else
      redirect_to show_page_path(@page.id, @page.int_title) if (params[:int_title] != @page.int_title)
      
      @page_content = select_by_language_id(@page.page_contents)
    end
  end
  
  def new
    @title = "create new page"
    @page = Page.create!(:page_type => :page, :enabled => false)
    @page_content = @page.page_contents.build(:title => "new page")
  end
  
  def edit
    @title = "edit page"
    @page = Page.find_by_id(params[:id])
    @page_content = select_by_language_id(@page.page_contents)
  end
  
  def destroy
    Page.find_by_id(params[:id]).destroy
    flash[:success] = "page deleted"
    
    redirect_to pages_path
  end
  
  def update
    @page = Page.find(params[:id])
    
    if @page.save
      redirect_to edit_page_path(@page)
    else
      render :action => "edit"
    end
  end
  
  def home
    default_page = Conf.get_default_page
    if default_page.nil?
      redirect_to setup_path
    else
      redirect_to view_context.make_page_path(default_page)
    end
  end
  
  def credits
  end
  
  def setup
  end
end