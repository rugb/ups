# == Schema Information
# Schema version: 20110225155059
#
# Table name: roles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  int_name   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base
  attr_accessible :name, :int_name

  has_many :users

  validate :name, :presence => true,
                   :length => { :maximum => 255 }
  validate :int_name, :presence => true,
                       :length => { :maximum => 20 }

  def int_name
    iname = read_attribute("int_name")

    iname.to_sym unless iname.nil?
  end

  def int_name=(intname)
    write_attribute("int_name", intname.to_s) unless intname.nil?
  end

  def to_sym
    int_name
  end

  def to_s
    iname = read_attribute("int_name")
  end
end
