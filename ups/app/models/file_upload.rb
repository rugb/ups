require 'carrierwave/orm/activerecord'

class FileUpload < ActiveRecord::Base
  attr_accessible :page_id, :filename, :file, :counter

  belongs_to :page

  mount_uploader :file, FileUploader
  
end
