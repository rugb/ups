# == Schema Information
# Schema version: 20110228183544
#
# Table name: page_contents
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  text        :text
#  excerpt     :text
#  page_id     :integer
#  language_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  html        :text
#

class PageContent < ActiveRecord::Base
  attr_accessible :title, :text, :html, :excerpt, :language_id, :language

  validates :title, :presence => true, :length => { :maximum => 50 }
  validates_numericality_of :page_id, :greater_than => 0, :allow_nil => true
  validates_numericality_of :language_id, :greater_than => 0
  validates :language_id, :presence => true

  belongs_to :page
  belongs_to :language

  before_save :update_int_title
  before_save :update_excerpt

  private
  def make_short_title(title)
    title.tr(" ", "_").downcase.tr("^a-z0-9_", "")
  end

  def make_excerpt(text)
    html.gsub(%r{</?[^>]+?>}, '')[0..255] if html.present?
  end

  def update_int_title
    if(page.int_title.blank? || ((page.parent.nil? || page.parent.int_title != "projects") && (page.page_contents.size == 1 || Conf.default_language == language)))
      page.int_title = make_short_title(title)
      page.save if page.changed?
    end
  end

  def update_excerpt
    self.excerpt = make_excerpt(text) if excerpt.blank?
  end
end
