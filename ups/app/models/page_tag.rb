# == Schema Information
# Schema version: 20110225155059
#
# Table name: page_tags
#
#  id         :integer         not null, primary key
#  page_id    :integer
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class PageTag < ActiveRecord::Base
  belongs_to :page
  belongs_to :tag
end
