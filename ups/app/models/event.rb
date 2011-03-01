# == Schema Information
# Schema version: 20110301093539
#
# Table name: events
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  user_id    :integer
#  location   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Event < ActiveRecord::Base
end
