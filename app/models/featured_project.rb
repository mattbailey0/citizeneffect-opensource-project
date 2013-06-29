class FeaturedProject < ActiveRecord::Base
  acts_as_list
  
  default_scope :order => "position"
  
  has_one_unified_attachment :picture
  has_one_unified_attachment :picture_thumbnail

  validates_presence_of :picture
  validates_presence_of :picture_thumbnail
  validates_presence_of :title
  validates_presence_of :caption
  validates_presence_of :url_identifier

  # READ_ONLY_FIELDS = [:id, :title, :caption]
  # READ_WRITE_FIELDS  = []
  # API_METHODS = [:picture_url, :picture_thumbnail_url, :url]
  # include ApiModelHelper

  def picture_url
    picture.url(:featured_project)
  end

  def picture_thumbnail_url
    picture_thumbnail.url(:featured_project_thumb)
  end

  def url
    url_identifier
  end
end
