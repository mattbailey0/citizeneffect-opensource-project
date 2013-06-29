# t.string   "title"
# t.string   "subtitle"
# t.string   "url_identifier"
# t.string   "stylesheet"
# t.datetime "created_at"
# t.datetime "updated_at"

class Blog < ActiveRecord::Base
  MAIN_BLOG_ID = 1

  has_many :blog_posts
  has_many :blog_categories
  
  belongs_to :project
  
  def self.main_blog
    @main_blog ||= self.find(MAIN_BLOG_ID)
  end
end
