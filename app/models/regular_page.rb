class RegularPage < ActiveRecord::Base
  named_scope :published, :conditions => ['published_at IS NOT NULL']

  PATH_BASE = "/p/"
  URL_BASE  = ONEWELL_HOST + PATH_BASE
  STATES = [PUBLISHED = 'published',
            DRAFT     = 'draft']

  validates_presence_of :title
  validates_presence_of :permalink_text
  validates_uniqueness_of :permalink_text
  validates_format_of :permalink_text, :with => /[-A-Za-z0-9]*/
  validates_presence_of :content
  
  def url
    URL_BASE + self.permalink_text
  end
  
  def path
    PATH_BASE + self.permalink_text
  end
  
  def status
    self.published? ? PUBLISHED : DRAFT
  end

  def draft
    self.published_at = nil
  end
  
  def publish
    self.published_at = DateTime.now.utc
  end
  
  def published?
    !self.published_at.blank?
  end
  
  def self.about_us
    @about_us ||= self.find_by_permalink_text("about_us")
  end
  
  def self.terms_of_service
    @terms_of_service ||= self.find_by_permalink_text("account-terms-of-service")
  end
end
