class LinkCategory < ActiveRecord::Base
  belongs_to :categories
  belongs_to :links
end
