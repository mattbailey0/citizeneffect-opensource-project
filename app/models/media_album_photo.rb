class MediaAlbumPhoto < ActiveRecord::Base
  has_one                      :media_album_media, :as => :media
  has_one                      :media_album, :through => :media_album_medias
  has_one                      :featured_media_association, :as => :featured_media
  belongs_to                   :user
  has_one_unified_attachment   :photo

#   validates_presence_of :title # makes album edit page file upload harder
  validates_presence_of :photo
  
  def url
    self.photo.url
  end
  
  def project # STUB for easy reference
    self.featured_media_association.andand.project ||
      self.media_album.andand.project ||
      Project.find_by_primary_photo_id(self.id)
  end
  
end
