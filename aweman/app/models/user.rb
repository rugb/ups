class User < ActiveRecord::Base
  attr_accessible :name, :email, :group_id
  
  email_regex = /\A[\w+\-.]{1,128}@[a-z\d\-.]{1,128}\.[a-z]{2,4}\z/i
  
  validates :name, :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true, :format => { :with => email_regex }, :uniqueness => { :case_sensitive => false }
  
  belongs_to :group
  
  def group_with!(user)
    return nil if user.nil? 
    
    group = Group.next
    
    user.group = group
    self.group = group
    
    user.save
    self.save
    
    return Group.find_by_id(group)
  end
end