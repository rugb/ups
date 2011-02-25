class User < ActiveRecord::Base
  attr_accessible :openid, :email, :name, :role_id
  
  has_many :pages
  has_many :comments
  
  belongs_to :role
  
  
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
    
    
    super(options)
  end
  
  def role_symbols
    [role.to_sym]
  end

end
