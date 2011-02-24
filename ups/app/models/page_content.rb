class PageContent < ActiveRecord::Base
  attr_accessible :title, :text, :excerpt, :language_id
  
  validates :title, :presence => true, :length => { :maximum => 50 }
  validates :page_id, :presence => true
  validates :language_id, :presence => true
  
  belongs_to :page
  belongs_to :language
  
  before_save :update_int_title
  
  def update_int_title
    if(page.int_title.blank? || Conf.get_default_language == language)
      page.int_title = make_short_title(title)
      page.save! if page.changed?
    end
  end
  
  private
  def make_short_title(title)
    title.tr(" ", "_").downcase.tr("^a-z0-9_", "")
  end
  
end
