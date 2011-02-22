class Conf < ActiveRecord::Base
  attr_accessible :name, :value
  
  validates :name, :presence => true, :length => 1..50
  validates_length_of :value, :in => 0..255, :allow_nil => true
  
  def self.get_default_language
    Language.find_by_short(get(:default_language))
  end
  
  def self.set_default_language(lang)
    raise "lang should not be nil" if lang.nil?
    lang.save if lang.changed?
    set(:default_language, lang.short)
  end
  
  def to_s
    name + ": " + value
  end
  
  def self.set(name, value)
    conf = Conf.find_by_name(name)
    if conf.nil?
      Conf.create!(:name => name, :value => value)
    else
      conf.value = value
      conf.save!
    end
  end
  
  def self.get(name)
    conf = Conf.find_by_name(name)
    return nil if conf.nil?
    conf.value
  end
end
