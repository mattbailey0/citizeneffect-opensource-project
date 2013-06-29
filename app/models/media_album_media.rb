class MediaAlbumMedia < ActiveRecord::Base
  belongs_to :media_album
  belongs_to :media, :polymorphic => true, :dependent => :destroy
  
  accepts_nested_attributes_for :media, :reject_if => lambda { |attrs|
    self.reject_media_attributes?(attrs)
  }
  
  acts_as_list :scope => :media_album
  
  after_destroy :update_album_cover
  
  def self.reject_media_attributes?(attrs)
    attrs["photo"].blank? && attrs["url"].blank?
  end
  
  def update_album_cover
    ma = self.media_album
    ma.default_cover
    ma.save
  end
  
  def build_media(attributes = {})
    klass = attributes.delete("type")
    raise "unknown media type" if klass.blank?
    self.media = klass.constantize.new(attributes)
  end
  
  def has_video?
    self.media_type == MediaAlbumVideo.name
  end
  
  def has_photo?
    self.media_type == MediaAlbumPhoto.name
  end
  
end
