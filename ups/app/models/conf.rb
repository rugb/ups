class Conf < ActiveRecord::Base
  validates_length_of :name, :in => 1..50
  validates_length_of :value, :in => 0..255, :allow_nil => true
  
  def self.get_default_language
    Language.find_by_short(get(:default_language))
  end
  
  private
  
  def self.set(name, value)
    conf = get(name)
    if conf.nil?
      Conf.create!(name, value)
    else
      conf.value= value
      conf.save
    end
  end
  
  def self.get(name)
    conf = Conf.find_by_name(name)
    return nil if conf.nil?
    conf.value
  end
end
