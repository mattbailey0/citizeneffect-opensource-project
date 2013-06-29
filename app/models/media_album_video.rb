class MediaAlbumVideo < ActiveRecord::Base
  include EmbeddedYoutube
  has_one     :media_album_media, :as => :media
  has_one     :media_album, :through => :media_album_medias
  has_one     :featured_media_association, :as => :featured_media
  belongs_to  :user
  
#   validates_presence_of :title # makes album edit page file upload harder
  validates_presence_of :url
  
  class YoutubePhoto
    def initialize(youtube_url)
      @youtube_id = youtube_url.match(/http:\/\/(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?/).andand[2]
    end
    # in case we figure out how to do some fancy sizing, as well as making it uniform with MediaAlbumPhoto
    def url(size_name) 
      if @youtube_id
        "http://img.youtube.com/vi/#{@youtube_id}/0.jpg"
      else
        "http://img.youtube.com/vi/0.jpg"
      end
    end
  end
  
  def youtube_video_id
    self.url.match(/http:\/\/(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?/).andand[2] || ""
  end
  
  # UnifiedUpload.new(:flavor => "video_thumb") # this actually works for returning a default image
  # STUB, hopefully we can make this act like MediaAlbumPhoto#photo for video thumbnails
  def photo 
    YoutubePhoto.new(self.url)
  end

  def project # STUB for easy reference
    self.featured_media_association.andand.project ||
      self.media_album.andand.project
  end
  
end
