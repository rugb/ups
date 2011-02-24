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
end
