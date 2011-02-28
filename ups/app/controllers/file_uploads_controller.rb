class FileUploadsController < ApplicationController
  before_filter :load_file_upload

  filter_access_to :show, :check_attributes => true
  
  filter_access_to :all
  
  def new
    @file_upload = FileUpload.new
  end

  def create
    @file_upload = FileUpload.new(params[:file_upload])

    if @file_upload.save
      flash[:success] = "file uploaded"
      redirect_to file_uploads_path
    else
      flash[:error] = "file not upload"
      render 'new'
    end
  end

  def update
  end

  def edit
  end

  def destroy
    @file_upload.destroy

    redirect_to file_uploads_path
  end

  def index
    @file_uploads = FileUpload.all
  end

  def show
    http_404 and return  if @file_upload.page.enabled == false

    #response.headers['Pragma'] = ' '
    #response.headers['Cache-Control'] = ' '
    response.headers['Content-type'] = 'application/octet-stream'
    response.headers['Content-Disposition'] = "attachment; filename=#{@file_upload.filename}"
    response.headers['Accept-Ranges'] = 'bytes'
    response.headers['Content-Length'] = "#{@file_upload.file.size}"
    response.headers['Content-Transfer-Encoding'] = 'binary'
    response.headers['Content-Description'] = 'File Transfer'
    
    render "show"
  end

  private

    def load_file_upload
      @file_upload = FileUpload.find(params[:id]) if (params[:id])
    end

end
