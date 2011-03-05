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
  attr_accessible :user_id, :user, :page, :text, :name, :email

  belongs_to :user
  belongs_to :page

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validate do |comment|
    comment.errors.add :user_id, "can't be blank" unless comment.user_id? || (comment.name? && comment.email?)

    comment.errors.add :name, "can't be blank" unless comment.name? || comment.user_id?

    comment.errors.add :email, "can't be blank" unless comment.email? || comment.user_id?
  end

  validates :name,   :length   => { :maximum => 255 },
                     :allow_nil => true
  validates :email,  :format     => { :with => email_regex },
                     :uniqueness => { :case_sensitive => false },
                     :length => { :maximum => 255 },
                     :allow_nil => true
  validates :text, :presence => true
  validates_numericality_of :user_id, :greater_than => 0, :allow_nil => true
end
