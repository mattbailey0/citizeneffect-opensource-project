module UrlShortener
  @@bitly = nil
  @@bitly_cache = { }
  
  def self.shorten(url)
    unless @@bitly_cache[url]
      begin
        Timeout.timeout(3) do
          @@bitly = Bitly.new(BITLY_USERNAME, BITLY_API_KEY) unless @@bitly
          @@bitly_cache[url] = @@bitly.shorten(url).short_url
        end
      rescue Exception => e
        @@bitly_cache[url] = url
      end
    end
    @@bitly_cache[url]
  end
  
end
