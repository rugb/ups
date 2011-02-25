class Language < ActiveRecord::Base
  attr_accessible :short, :name
  
  validates :short, :presence => true, :length => 2..2, :uniqueness => true
  validates :name, :presence => true, :length => { :maximum => 255 }, :uniqueness => true
  
  default_scope :order => "languages.name"
  
  def to_s
    name + " (" + short + ")" if valid?
  end
  
  def self.find_by_any(any)
    if (any.is_a?(Integer))
      return Language.find_by_id(any)
    elsif (any.is_a?(String))
      if (any.size == 2)
        return Language.find_by_short(any)
      elsif (any.size > 2)
        return Language.find_by_name(any)
      end
    end
    
    NIL
  end
end
