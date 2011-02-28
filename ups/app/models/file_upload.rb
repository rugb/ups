class FileUpload < ActiveRecord::Base
  attr_accessible :page_id, :filename, :file, :count, :size

  belongs_to :page

  mount_uploader :file, FileUploader

   def initialize(options = {})
     super(options)

     self.count = 0

     if file.present?
       self.filename = file.filename if options[:filename].blank?
       self.size = file.size if self.size.nil?
     end
   end
end
