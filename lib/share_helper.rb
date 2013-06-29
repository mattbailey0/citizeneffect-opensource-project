module ShareHelper
  SHARE_TYPES = [
    { 
      :url_proc => lambda do |title, url, bitlyurl| 
        "http://twitter.com/home/?status=#{title}+#{bitlyurl}+%23CitizenEffect"
      end,
      :name => "Retweet",
      :icon => "icon_twitter_large.png"
    },
    { 
      :url_proc => lambda {|title, url, bitlyurl| "http://reddit.com/submit?url=#{url}&title=#{title}"},
      :name => "Reddit",
      :icon => "icon_reddit_large.png"
    },
    { 
      :url_proc => lambda {|title, url, bitlyurl| "http://www.facebook.com/share.php?u=#{url}&t=#{title}"},
      :name => "Share on Facebook",
      :icon => "icon_facebook_large.png"
    },
    { 
      :url_proc => lambda {|title, url, bitlyurl| "http://digg.com/submit?phase=2&url=#{url}&title=#{title}"},
      :name => "Digg",
      :icon => "icon_digg_large.png"
    },
    { 
      :url_proc => lambda do |title, url, bitlyurl| 
        "http://www.myspace.com/Modules/PostTo/Pages/?l=3&u=#{url}&t=#{title}s&c=%3Cp%3EPowered%20by%20%3Ca%20href%3D%22http%3A%2F%2Fcitizeneffect.org%22%3ECitizen%20Effect%3C%2Fa%3E%3C%2Fp%3E"
      end,
      :name => "Share on MySpace",
      :icon => "icon_myspace_large.png"
    },
    { 
      :url_proc => lambda {|title, url, bitlyurl| "http://friendfeed.com/share?url=#{url}&title=#{title}"},
      :name => "FriendFeed",
      :icon => "icon_friendfeed_large.png"
    },
    { 
      :url_proc => lambda {|title, url, bitlyurl| "http://delicious.com/post?url=#{url}&title=#{title}"},
      :name => "Delicious",
      :icon => "icon_delicious_large.png"
    },
    { 
      :url_proc => lambda do |title, url, bitlyurl| 
        "http://www.linkedin.com/shareArticle?mini=true&url=#{url}&title=#{title}&summary=&source="
      end,
      :name => "LinkedIn",
      :icon => "icon_linkedin_large.png"
    },
    { 
      :url_proc => lambda {|title, url, bitlyurl| "http://www.stumbleupon.com/submit?url=#{url}&title=#{title}"},
      :name => "StumbleUpon",
      :icon => "icon_stumbleupon_large.png"
    }
  ]
  
end
