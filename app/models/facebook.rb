class Facebook
  BASE_URI = "https://graph.facebook.com"

  include HTTParty
  base_uri BASE_URI
  
  def self.get_redirect_path(callback)
    callback = CGI.escape(callback)
    "#{BASE_URI}/oauth/authorize?client_id=#{FACEBOOK_APP_ID}&redirect_uri=#{callback}&scope=publish_stream,offline_access"
  end
  
  def self.get_token(code, callback)
    params = { 
      :client_id => FACEBOOK_APP_ID,
      :client_secret => FACEBOOK_SECRET,
      :redirect_uri => callback,
      :code => code
    }
    response = get("/oauth/access_token", :query => params)
    if response =~ /^access_token=/
      response.gsub(/^access_token=/, '')
    else
      ActiveRecord::Base.logger.error "Facebook error: #{response}"
      nil
    end
  end
  
  def self.push_status(token, message)
    params = { 
      :access_token => token,
      :message => message
    }
    
    post("/me/feed", :body => params)
  end

end
