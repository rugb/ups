# == Schema Information
# Schema version: 20110225155059
#
# Table name: users
#
#  id         :integer         not null, primary key
#  openid     :string(255)
#  email      :string(255)
#  name       :string(255)
#  role_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  fullname   :string(255)
#  salt       :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :openid, :email, :name, :role_id, :fullname
  
  has_many :pages
  has_many :comments
  
  belongs_to :role

  before_destroy :remove_user_from_all
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :openid, :length => { :maximum => 255 },
		     :allow_nil => true
  validates :name,   :length   => { :maximum => 255 },
		     :allow_nil => true
  validates :email,  :format     => { :with => email_regex },
                     :uniqueness => { :case_sensitive => false },
		     :length => { :maximum => 255 },
		     :allow_nil => true
  
  validate do |user|
    if user.role.nil?
      user.errors.add :role_id, "role should be guest"  if user.openid.blank? && user.name.blank? && user.email.blank?
    elsif user.role.present? && user.role.int_name != :guest
      user.errors.add :openid, "openid can't be blank" if user.openid.blank?
      user.errors.add :name, "name can't be blank" if user.name.blank?
      user.errors.add :email, "email can't be blank" if user.email.blank?    
    end
  end
  
  def initialize(options = {})
    options[:role_id] = Role.find_by_int_name(:guest).id if options[:role_id].nil?
    options[:openid].strip! if options[:openid].present?
    
    super(options)
    
    self.salt = make_salt if new_record?
  end
  
  def role_symbols
    [role.to_sym]
  end
  
  def to_s
    "Name: #{self.name}, E-Mail: #{self.email} (#{self.role})"
  end
  
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private
  
    def make_salt
      if openid.present?
	secure_hash("#{Time.now.utc}--#{secure_hash(openid)}")
      else
	nil
      end
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

    def remove_user_from_all
      Page.update_all({:user_id => nil}, {:user_id => id})
      Comment.update_all({:user_id => nil, :name => fullname, :email => email}, {:user_id => id})
    end
end
