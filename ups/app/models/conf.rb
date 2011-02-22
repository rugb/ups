class Conf < ActiveRecord::Base
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
