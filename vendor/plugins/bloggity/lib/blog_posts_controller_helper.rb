module BlogPostsControllerHelper
  private
	def recent_posts(blog_show_params)
		BlogPost.paginate(:all, :select => "DISTINCT blog_posts.*", :conditions => ["blog_id = ? AND is_complete = ?", @blog_id, true], :order => "blog_posts.created_at DESC", :page => blog_show_params[:page] || 1, :per_page => 15)		
	end
  
  def blog_show_params # RAGE, fix for bloggity trying to use will_paginate with non-standard options
    opts = {}
    opts[:page] = params[:page] if params[:page]
    params[:blog_show_params] || opts
  end
end
