class LinkCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :link
end
