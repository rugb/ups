class PageContentsController < ApplicationController
  before_filter :load_page

  filter_access_to :all
  
  def new
    @page_content = @edit_page.page_contents.build
    @page_content.language = @language
  end
  
  def create
    @page_content = @edit_page.page_contents.build(params[:page_content]) if @page_content.nil?
    
    @edit_page.save if @edit_page.changed?
    if @page_content.save
      flash[:success] = "page content created."
      redirect_to edit_page_content_page_path(@edit_page.id, @language.id)
    else
      flash[:error] = "page content creation failed."
      render :action => :new
    end
  end
  
  def edit
    @page_content = @edit_page.page_contents.find(:first, :conditions => { :language_id => @language.id })
  end
  
  def update
    @page_content = @edit_page.page_contents.find(:first, :conditions => { :language_id => @language.id })
    
    if(@page_content.update_attributes(params[:page_content]))
      flash[:success] = "page content updated."
      redirect_to edit_page_content_page_path(@edit_page.id, @language.id)
    else
      flash[:error] = "page content update failed."
      render :action => :edit
    end
  end
  
  def destroy
    @page_content = @edit_page.page_contents.find(:first, :conditions => { :language_id => @language.id })
    @page_content.destroy
    flash[:success] = "page content deleted."
    
    redirect_to edit_page_path(@edit_page)
  end
  
  private
  def load_page
    @edit_page = Page.find(params[:id])
    http_404 and return if @edit_page.nil?
    @language = Language.find(params[:language_id])
    http_404 and return if @language.nil?
  end
  
end