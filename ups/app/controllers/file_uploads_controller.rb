class FileUploadsController < ApplicationController
  filter_access_to :show

  before_filter :check_for_page_rights, :except => :show
  before_filter :load_file_upload, :only => [:edit, :update, :destroy]

  include PagesHelper

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
    http_404 and return  if @file_upload.nil?

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
  end

  def destroy
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
  def check_for_page_rights
    if params[:page_id].present?
      id = params[:page_id]
    elsif params[:file_upload].present? && params[:file_upload][:page_id].present?
      id = params[:file_upload][:page_id]
    end
    @edit_page = Page.find_by_id(id) if id.present?
    @edit_page ||= FileUpload.find_by_id(params[:id]).page

    permission_denied and return unless @edit_page.nil? || page_editable?(@edit_page)
  end

  def load_file_upload
    @file_upload = FileUpload.find_by_id params[:id] if (params[:id])
  end
end
