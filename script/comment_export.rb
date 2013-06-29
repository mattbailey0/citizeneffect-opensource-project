API_KEY = ""
FORUM_API_KEY = ""
require 'httparty'
require 'ruby-debug'

class Disqus
  include HTTParty
  format :json
end

BlogPost.find_each do |post|
  next if post.comments.empty?
  result = Disqus.post("http://disqus.com/api/thread_by_identifier?user_api_key=#{API_KEY}&api_version=1.1", 
                         :body => { 
                           :identifier => post.id,
                           :forum_api_key => FORUM_API_KEY,
                           :title => post.title,
                           :create_on_fail => 1
                         })

  thread_id = result["message"]["thread"]["id"]
  post.comments.each do |comment|
    result = Disqus.post("http://disqus.com/api/create_post?user_api_key=#{API_KEY}&api_version=1.1", 
                           :body => { 
                             :thread_id => thread_id,
                             :message => comment.comment,
                             :author_name => comment.user.display_name,
                             :author_email => comment.user.email,
                             :forum_api_key => FORUM_API_KEY,
                             :created_at => comment.created_at.utc.strftime("%Y-%m-%dT%H:%M"),
                           })
    puts result
  end
end
