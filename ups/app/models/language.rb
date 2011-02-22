class Language < ActiveRecord::Base
  attr_accessible :short, :name
  
  validates :short, :presence => true, :length => 2..2
  validates :name, :presence => true, :length => { :maximum => 255 }
  
  def to_s
    name + " (" + short + ")" if valid?
  end
end
