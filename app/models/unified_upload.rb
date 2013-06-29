class UnifiedUpload < ActiveRecord::Base
  IMAGE_SIZES = {
    :fundraiser_type_show       => "636x302",
    :project_featured_media     => "634x258",
    :project_featured_media_jpg => "634x258",
    :featured_project           => "629x391",
    :album_lightbox             => "613x306",
    :watch_list                 => "185x130", 
    :album                      => "182x111", 
    :profile_project            => "182x111", 
    :partner_logo               => "180x65",
    :fundraiser_type_carousel   => "175x105", 
    :carousel_3                 => "162x111", 
    :profile                    => "113x112",
    :featured_project_thumb     => "67x67",
    :project_needs_you          => "62x88",
    :watched_project_cp         => "50x50",
    :edit_featured_media_thumb  => "50x50",
    :tiny_fundraiser_type_thumb => "50x50",
    :tiny_blog_post_thumb       => "50x50",
    :standard_thumb             => "50x49",
    :news_item                  => "22x28",
    :imported_contact_thumb     => "20x20"
  }
  
  # as well as constraining the size, let's convert everything to png so transparency works
  IMAGE_STYLES = IMAGE_SIZES.inject({}) do |m, o|
    if o.first == :featured_project || o.first == :project_featured_media_jpg
      m[o.first] = ["#{o.second}^", :jpg]
    else
      m[o.first] = ["#{o.second}>", :png]
    end
    m
  end
  
  # pad out the image with transparency and center it, so we don't have to jump through css hoops to make things look good
  CONVERT_OPTIONS = IMAGE_SIZES.inject({}) do |m, o|
    m[o.first] = "-gravity center -extent #{o.second} -quality 75"
    m
  end
  
  belongs_to :uploadable, :polymorphic => true
  has_attached_file :content, PAPERCLIP_OPTIONS.merge({ 
                                                        :whiny => false, 
                                                        :styles => IMAGE_STYLES.dup, # paperclip modifies hash
                                                        :convert_options => CONVERT_OPTIONS,
                                                        :default_url => "/default_images/:class/:flavor/:attachment/:style/image.png"
                                                      })
                              
    
  
  validates_presence_of :flavor
  
  delegate :url, :path, :content_type, :original_filename, :to => :content, :allow_nil => true
end
