module SocialUrlHelper
  FOLLOW_URL_TYPES = [
                      :facebook,
                      :linkedin,
                      :myspace,
                      :twitter,
                      :youtube,
                     ]
  
  FOLLOW_URL_BASES = {
    :facebook => "http://www.facebook.com/",
    :linkedin => "http://linkedin.com/",
    :myspace  => "http://www.myspace.com/",
    :twitter  => "http://twitter.com/",
    :youtube  => "http://www.youtube.com/"
  }
  
  FOLLOW_URL_NAMES = { 
    :facebook => "Facebook",
    :linkedin => "LinkedIn",
    :myspace  => "MySpace",
    :twitter  => "Twitter",
    :youtube  => "YouTube"
  }
  
  def self.included(klass)
    klass.extend ClassMethods
  end
  
  def follow_urls
    urls = FOLLOW_URL_TYPES.map do |type| 
      path = self.follow_path(type)
      if path.blank?
        nil
      else
        { 
          :url           => "#{FOLLOW_URL_BASES[type]}#{path}",
          :display_name  => FOLLOW_URL_NAMES[type],
          :type          => type
        }
      end
    end
    urls.compact
  end
  
  def follow_path(type)
    self.read_attribute("#{type}_path")
  end
  
  module ClassMethods
    def valid_follow_url_types
      FOLLOW_URL_TYPES.reject{ |t| !self.column_names.include? "#{t}_path" }
    end
  end

end
