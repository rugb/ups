class PageContent < ActiveRecord::Base
  attr_accessible :title, :text, :excerpt, :language_id
  
  validates :title, :presence => true, :length => { :maximum => 50 }
  validates :page_id, :presence => true
  validates :language_id, :presence => true
  
  belongs_to :page
  belongs_to :language
  
  before_save :update_int_title
  
  def update_int_title
    #if (Conf.get_default_language == language || page.page_contents.size == 1)
    if(page.int_title.blank?)
      page.int_title = make_short_title(title)
      page.save
    end
  end
  
  private
  def make_short_title(title)
    title.sub(" ", "_").downcase.sub("[^a-z0-9_]", "")
  end
  
end
