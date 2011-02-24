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
end
