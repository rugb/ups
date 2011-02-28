
class FileUploadsController < ApplicationController
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
    @file_upload = FileUpload.find(params[:id])

    @file_upload.destroy

    redirect_to file_uploads_path
  end

  def index
    @file_uploads = FileUpload.all
  end

  def show
    @file_upload = FileUpload.find(params[:id])
  end

end
