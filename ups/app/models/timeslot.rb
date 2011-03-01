# == Schema Information
# Schema version: 20110301093539
#
# Table name: timeslots
#
#  id         :integer         not null, primary key
#  start_at   :datetime
#  end_at     :datetime
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Timeslot < ActiveRecord::Base
end
