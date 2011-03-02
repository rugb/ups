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

  def self.calendar
    get(:calendar_url)
  end

  def self.calendar=(calendar_url)
    set(:calendar_url, calendar_url)
  end

  def self.google_account_name
    get(:google_account_name)
  end

  def self.google_account_name=(google_account_name)
    set(:google_account_name, google_account_name)
  end

  def self.google_account_password
    get(:google_account_password)
  end
  
  def self.google_account_password=(google_account_password)
    set(:google_account_password, google_account_password)
  end
  
  def self.twitter_consumer_key
    get(:twitter_consumer_key).to_s
  end

  def self.twitter_consumer_key=(consumer_key)
    set(:twitter_consumer_key, consumer_key)
  end

  def self.twitter_consumer_secret
    get(:twitter_consumer_secret)
  end

  def self.twitter_consumer_secret=(consumer_secret)
    set(:twitter_consumer_secret, consumer_secret)
  end

  def self.twitter_oauth_token
    get(:twitter_oauth_token).to_s
  end

  def self.twitter_oauth_token=(oauth_token)
    set(:twitter_oauth_token, oauth_token)
  end

  def self.twitter_oauth_secret
    get(:twitter_oauth_secret).to_s
  end

  def self.twitter_oauth_secret=(oauth_secret)
    set(:twitter_oauth_secret, oauth_secret)
  end

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
