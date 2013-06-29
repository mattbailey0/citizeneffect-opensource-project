module EmbeddedYoutube
  def embedded_html
    self.url.gsub(/http:\/\/(www.)?youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)(\&\S+)?/) do
      youtube_id = $2
      %{<object width="629" height="391"><param name="movie" value="http://www.youtube.com/v/#{youtube_id}"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/#{youtube_id}" type="application/x-shockwave-flash" wmode="transparent" width="629" height="391"></embed></object>}
    end
  end
end
