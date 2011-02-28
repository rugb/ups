class FileUploadsController < ApplicationController
  filter_access_to :all
  
  def new
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
  end

  def edit
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

    #response.headers['Pragma'] = ' '
    #response.headers['Cache-Control'] = ' '
    response.headers['Content-type'] = 'application/octet-stream'
    response.headers['Content-Disposition'] = "attachment; filename=#{@file_upload.filename}"
    response.headers['Accept-Ranges'] = 'bytes'
    response.headers['Content-Length'] = "#{@file_upload.file.size}"
    response.headers['Content-Transfer-Encoding'] = 'binary'
    response.headers['Content-Description'] = 'File Transfer'

    @file_upload.count += 1
    @file_upload.save!
    
    render "show"
  end
end
