# == Schema Information
# Schema version: 20090406223746
#
# Table name: blog_posts
#
#  id              :integer(4)      not null, primary key
#  title           :string(255)     
#  body            :text            
#  is_indexed      :boolean(1)      
#  tag_string      :string(255)     
#  posted_by_id    :integer(4)      
#  is_complete     :boolean(1)      
#  created_at      :datetime        
#  updated_at      :datetime        
#  url_identifier  :string(255)     
#  comments_closed :boolean(1)      
#  category_id     :integer(4)      
#  fck_created     :boolean(1)      
#  blog_id     :integer(4)      
#

class BlogPost < ActiveRecord::Base
  include CommonNamedScopes
  
	belongs_to :posted_by, :class_name => 'User'
  belongs_to :category, :class_name => 'BlogCategory'
	has_many   :comments, :class_name => 'BlogComment'
	has_many   :approved_comments, :conditions => %{approved = true}, :class_name => 'BlogComment'
	has_many   :assets, :class_name => 'BlogAsset'
	has_many   :tags, :class_name => 'BlogTag'
  has_many   :media_album_displayers, :as => :displayer
  has_many   :media_albums, :through => :media_album_displayers
	belongs_to :blog
  
  named_scope :newest, :order => "created_at DESC"
  
	validates_presence_of :blog_id, :posted_by_id
  validates_presence_of :category_id, :if => :is_complete?
  validates_presence_of :title, :if => :is_complete?
  validates_presence_of :excerpt, :if => :is_complete?
  validates_presence_of :url_identifier, :if => :is_complete?
	validate :authorized_to_blog?
  
  has_permalink :title, :url_identifier
	
	# Recommended... but only if you have it:
	# xss_terminate :except => [ :body ]
	after_save :save_tags
  before_create :clear_permalink, :unless => :is_complete?
	
	def comments_closed?
		self.comments_closed
	end
  
  def similar_posts
    BlogPost.random.scoped(:conditions => { :is_complete => true })
  end
  
  #clear out permalink_fu random permalink after create, since bloggity always creates before edit
  def clear_permalink 
    self.url_identifier = ""
  end
  
  def duplicate_to(blog, user)
    post = self.clone
    post.blog = blog
    post.assets = self.assets.map(&:clone)
    post.tags = self.tags.map(&:clone)
    post.posted_by = user
    post.created_at = DateTime.now
    post.save ? post : false
  end
	
	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	private
	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	
	def authorized_to_blog?
		unless(self.posted_by && self.posted_by.can_blog?(self.blog_id))
			self.errors.add(:posted_by_id, "is not authorized to post to this blog")
		end
	end
	
	def save_tags
		return if self.tag_string.blank?
		BlogTag.delete_all(["blog_post_id = ?", self.id])
		these_tags = self.tag_string.split(",")
		these_tags.each do |tag|
			sanitary_tag = tag.strip.chomp
			BlogTag.create(:name => sanitary_tag, :blog_post_id => self.id)
		end
	end

end
