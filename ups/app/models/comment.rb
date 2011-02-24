class Comment < ActiveRecord::Base
  attr_accessible :user_id, :text, :name, :email
  
  belongs_to :user
  belongs_to :page
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validate do |comment|
    comment.errors.add :user_id, "user_id can't be blank" if
      user_id_invalid? &&
      (comment.name.blank? && comment.email.blank?)
      
    comment.errors.add :name, "name can't be blank" if
      comment.name.blank? && user_id_invalid?
      
    comment.errors.add :email, "email can't be blank" if
      comment.email.blank? && user_id_invalid?
  end
  
  validates :name,   :length   => { :maximum => 255 },
                     :allow_nil => true
  validates :email,  :format     => { :with => email_regex },
                     :uniqueness => { :case_sensitive => false },
                     :length => { :maximum => 255 },
                     :allow_nil => true
  validates :user_id, :presence => true,
                      :allow_nil => true
  validates_numericality_of :user_id, :greater_than => 0
  
  private
  
    def user_id_invalid?
      user_id.nil? || (user_id.present? && user_id == 0)
    end
end
