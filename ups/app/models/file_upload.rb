# == Schema Information
# Schema version: 20110301084838
#
# Table name: file_uploads
#
#  id         :integer         not null, primary key
#  page_id    :integer
#  filename   :string(255)
#  file       :string(255)
#  count      :integer
#  created_at :datetime
#  updated_at :datetime
#  size       :integer
#  visible    :boolean
#

class FileUpload < ActiveRecord::Base
  attr_accessible :page_id, :filename, :file, :count, :size

  belongs_to :page

  mount_uploader :file, FileUploader

   def initialize(options = {})
     super(options)

     self.count = 0

     if file.present?
       if options[:filename].blank?
         self.filename = file.filename
       else
         self.file.filename = options[:filename]
       end
       self.size = file.size if self.size.nil?
     end
   end
end
