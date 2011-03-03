class FileUploadsController < ApplicationController
  filter_access_to :new, :attribute_check => true, :model => Page, :load_method => :load_page
  
  def new
    @title = "upload file"
    @file_upload = FileUpload.new
    @file_upload.page_id = params[:page_id]
  end
  
  def create
    @file_upload = FileUpload.new(params[:file_upload])
    
    if @file_upload.save
      flash[:success] = "file uploaded"
      redirect_to edit_news_path(@file_upload.page)
    else
      flash.now[:error] = "file not upload"
      render 'new'
    end
  end
  
  def update
    @file_upload = FileUpload.find(params[:id])
    
    @file_upload.update_attributes(params[:file_upload])
    
    if @file_upload.save
      flash[:success] = "file updated"
      redirect_to edit_news_path(@file_upload.page)
    else
      flash.now[:error] = "file not updated"
      render 'new'
    end
  end
  
  def edit
    @title = "edit upload"
    @file_upload = FileUpload.find(params[:id]) if (params[:id])
  end
  
  def destroy
    @file_upload = FileUpload.find(params[:id]) if (params[:id])
    @file_upload.destroy
    
    if @file_upload.page.present? 
      redirect_to edit_news_path(@file_upload.page)
    else
      redirect_to file_uploads_path
    end
  end
  
  def index
    @file_uploads = FileUpload.all
  end
  
  def show
    @file_upload = FileUpload.find(params[:id]) if (params[:id])
    http_404 and return  if @file_upload.page.present? && @file_upload.page.enabled == false
    
    @file_upload.count += 1
    @file_upload.save!
    
    send_data @file_upload.file.file.read, :filename => @file_upload.filename
  end

  private
  def load_page
    Page.find_by_id params[:id]
  end
end
