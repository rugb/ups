class User < ActiveRecord::Base
  attr_accessible :openid, :email, :name, :role
  
  has_many :pages
  has_many :comments
  
  belongs_to :role
  
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :openid, :presence => true, 
                     :length => { :maximum => 255 }
  validates :name,   :presence => true, 
		     :length   => { :maximum => 255 }
  validates :email,  :presence   => true,
                     :format     => { :with => email_regex },
                     :uniqueness => { :case_sensitive => false },
		     :length => { :maximum => 255 }
  
  validate do |user|
    user.errors.add :role, "role should be guest" if user.role.present? && user.role.int_name != :guest && user.openid.blank? && user.name.blank? && user.email.blank?
  end
  
  def initialize(options = {})
    if (options[:role_id].nil?)
      options[:role_id] = Role.find_by_int_name(:guest)
    end
    
    super(options)
  end
end
