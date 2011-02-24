class Role < ActiveRecord::Base
  attr_accessible :name, :int_name
  
  has_many :users
  
  validate :name, :presence => true,
                   :length => { :maximum => 255 }
  validate :int_name, :presence => true,
                       :length => { :maximum => 20 }
end
