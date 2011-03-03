# == Schema Information
# Schema version: 20110225155059
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  email      :string(255)
#  page_id    :integer
#

class Comment < ActiveRecord::Base
  attr_accessible :user_id, :text, :name, :email
  
  belongs_to :user
  belongs_to :page
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validate do |comment|
    comment.errors.add :user_id, "can't be blank" if comment.user_id.blank? && (comment.name.blank? && comment.email.blank?)
      
    comment.errors.add :name, "can't be blank" if comment.name.blank? && comment.user_id.nil?
      
    comment.errors.add :email, "can't be blank" if comment.email.blank? && comment.user_id.nil?
  end
  
  validates :name,   :length   => { :maximum => 255 },
                     :allow_nil => true
  validates :email,  :format     => { :with => email_regex },
                     :uniqueness => { :case_sensitive => false },
                     :length => { :maximum => 255 },
                     :allow_nil => true
  validates_numericality_of :user_id, :greater_than => 0, :allow_nil => true
end
