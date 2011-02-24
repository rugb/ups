class PageContentController < ApplicationController
  before_filter :load_page
  
  def new
    @page_content = @page.page_contents.build
    @page_content.language = @language
  end
  
  def create
    @page_content = @page.page_contents.find(:first, :conditions => { :language_id => @language.id })
    @page_content = @page.page_contents.build(params[:page_content]) if @page_content.nil?
    
    if @page_content.save
      flash[:success] = "page content created."
      redirect_to edit_page_content_page_path(@page.id, @language.id)
    else
      flash[:error] = "page content creation failed."
      render :action => :new
    end
  end
  
  def edit
    @page_content = @page.page_contents.find(:first, :conditions => { :language_id => @language.id })
  end
  
  def update
    @page_content = @page.page_contents.find(:first, :conditions => { :language_id => @language.id })
    
    if(@page_content.update_attributes(params[:page_content]))
      flash.success "page content updated."
      redirect_to edit_page_content_page_path(@page.id, @language.id)
    else
      flash[:error] = "page content update failed."
      render :action => :edit
    end
  end
  
  def destroy
    @page_content = @page.page_contents.find(:first, :conditions => { :language_id => @language.id })
    @page_content.destroy
    flash[:success] = "page content deleted."
    
    redirect_to edit_page_path(@page)
  end
  
  private
  def load_page
    @page = Page.find(params[:id])
    http_404 and return if @page.nil?
    @language = Language.find(params[:language_id])
    http_404 and return if @language.nil?
  end
  
end
