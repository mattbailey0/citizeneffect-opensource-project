class MediaAlbum < ActiveRecord::Base
  default_scope :order => "updated_at DESC"
  
  belongs_to :project
  belongs_to :user
  belongs_to :album_cover, :class_name => "MediaAlbumPhoto"
  
  has_many_polymorphs :displayers, 
                      :from => [:project_events, :blog_posts], 
                      :through => :media_album_displayers
  
  has_many_polymorphs :medias, 
                      :from => [:media_album_photos, :media_album_videos], 
                      :through => :media_album_medias,
                      :order => "media_album_medias.position"
  reflect_on_association(:media_album_medias).options[:order] = "position"
  
  named_scope :with_cover,
              :conditions => "album_cover_id is not null"
  
  validates_presence_of :title
  validates_presence_of :user_id
    
  before_save :force_saving_of_media_album_medias, :default_cover
  
  accepts_nested_attributes_for :media_album_medias, :reject_if => lambda { |attrs|
    MediaAlbumMedia.reject_media_attributes?(attrs["media_attributes"])
  }
  
  # For reasons not yet understood, Rails refuses to save these child objects regardless
  # of the state of the parent.
  def force_saving_of_media_album_medias
    self.updated_at = DateTime.now
    self.media_album_medias.map(&:save)
  end
  
  def default_cover
    self.album_cover ||= self.media_album_medias.detect{ |m| MediaAlbumPhoto.name == m.media_type }.andand.media
  end
  
  alias :photos :media_album_photos
  alias :videos :media_album_videos
  
end

