class User < ActiveRecord::Base
  has_many :pages
  has_many :comments
end
