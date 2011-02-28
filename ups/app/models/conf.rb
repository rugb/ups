# == Schema Information
# Schema version: 20110225155059
#
# Table name: confs
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Conf < ActiveRecord::Base
  attr_accessible :name, :value
  
  validates :name, :presence => true, :length => 1..50
  validates_length_of :value, :in => 0..255, :allow_nil => true
  
  def self.web_name
    get(:web_name).to_s
  end
  
  def self.web_name=(name)
    return false if name.blank?
    set(:web_name, name)
  end
  
  def self.default_language
    Language.find_by_short(get(:default_language))
  end
  
  def self.default_language=(lang)
    return false if lang.nil?
    lang.save if lang.changed?
    set(:default_language, lang.short)
  end
  
  def self.default_page
    Page.find_by_id(get(:default_page))
  end
  
  def self.default_page=(page)
    return false if page.nil?
    page.save if page.changed?
    set(:default_page, page.id)
  end
  
  def to_s
    name + ": " + value
  end
  
  private
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
