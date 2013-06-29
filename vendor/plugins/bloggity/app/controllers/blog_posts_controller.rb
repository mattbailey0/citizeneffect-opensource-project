class BlogPostsController < ApplicationController
  
  include BlogPostsControllerHelper
  
  layout "application"
  
  before_filter :get_bloggity_page_name
	before_filter :load_blog_post
	before_filter :blog_writer_or_redirect, :except => [:close, :index, :show, :feed, :iframe]
  skip_after_filter :store_get_request_location, :only => [:iframe]
  skip_after_filter :add_google_analytics_code, :only => [:iframe]
	
	# GET /blog_posts
  # GET /blog_posts.xml
  def index
    @project = Blog.find(@blog_id).project
# 		blog_show_params = params[:blog_show_params] || {}
    @recent_posts = recent_posts(blog_show_params)
		@blog_posts = if(params[:tag_name] || params[:category_id])
			# This is how I'd *like* to filter on tag/category:  
			#search_condition = { :blog_id => @blog_id, :is_complete => true }
			#search_condition.merge!(:blog_tags => { :name => params[:tag_name] }) if params[:tag_name]
			# However something about the interaction of these options is terminally dumb, as the include or join 
			# is ignored by the test suite or script/server, respectively, when using this logic.
			
			# So alas... we must hack away:
			search_condition = ["blog_id = ? AND is_complete = ? #{'AND blog_tags.name = ?' if params[:tag_name]} #{'AND category_id = ?' if params[:category_id]}", @blog_id, true, params[:tag_name], params[:category_id]].compact
			BlogPost.paginate(:all, :select => "DISTINCT blog_posts.*", :conditions => search_condition, :include => :tags, :order => "blog_posts.created_at DESC", :page => blog_show_params[:page] || 1, :per_page => 15)
		else
			@recent_posts
		end
		
		@page_name = @blog.title
    
		respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blog_posts }
    end
  end
	
	def close
		@blog_post = BlogPost.find(params[:id])
		@blog_post.update_attribute(:comments_closed, true)
		flash[:notice] = "Commenting for this blog has been closed."
		redirect_to blog_named_link(@blog_post)
	end

	# Upload a blog asset
	def create_asset
		image_params = params[:blog_asset] || {}
		@image = BlogAsset.new(image_params)
		@image.blog_post_id = image_params[:blog_post_id] # Can't mass-assign attributes of attachment_fu, so we'll set it manually here
		@image.save!
		render :text => @image.public_filename
	end
	
  # GET /blog_posts/1
  # GET /blog_posts/1.xml
  def show
    @project = Blog.find(@blog_id).project # CE
    
# 		blog_show_params = params[:blog_show_params] || {}
		@recent_posts = recent_posts(blog_show_params)

		if !@blog_post || (!@blog_post.is_complete && !current_user.andand.can_blog?(@blog_post.blog_id))
			@blog_post = nil
			flash[:error] = "You do not have permission to see this blog."
			return (redirect_to( :action => 'index' ))
		else
			@page_name = @blog_post.title
		end
    
    @blog_posts = @project ? @blog_post.similar_posts.top_5.all : @blog_post.similar_posts.top_15.all # CE
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog_post }
    end
  end
  
  def iframe
    @blog_post = BlogPost.find(params[:id])
    @blog_post = nil if !@blog_post || (!@blog_post.is_complete && !current_user.andand.can_blog?(@blog_post.blog_id))
    
    render :action => "iframe", :layout => false
  end

  # GET /blog_posts/new
  # GET /blog_posts/new.xml
  def new
    @blog_post = BlogPost.new(:posted_by_id => current_user.id, :fck_created => true, :blog_id => @blog_id)
		@blog_post.save! # save it before we start editing it so we can know it's ID when it comes time to add images/assets
		redirect_to blog_named_link(@blog_post, :edit)
  end

  # GET /blog_posts/1/edit
  def edit
		@blog_post = BlogPost.find(params[:id])
  end

  # POST /blog_posts
  # POST /blog_posts.xml
  def create
		@blog_post = BlogPost.new(params[:blog_post])
	  @blog_post.posted_by = current_user

		if(@blog_post.save)
			redirect_to blog_named_link(@blog_post)
		else
			render blog_named_link(@blog_post, :new)
		end
  end

  # PUT /blog_posts/1
  # PUT /blog_posts/1.xml
  def update
    @blog_post = BlogPost.find(params[:id])
    
    @blog_post.is_complete = true if params["save_and_publish.x"]
    
    if @blog_post.update_attributes(params[:blog_post])
      if @blog_post.is_complete?
        flash[:notice] = "New blog post created."
      else
        flash[:notice] = "Blog post draft saved."
      end
      redirect_to blog_named_link(@blog_post)
    else
      render blog_named_link(@blog_post, :edit)
    end
  end

  # DELETE /blog_posts/1
  # DELETE /blog_posts/1.xml
  def destroy
		@blog = @blog_post.blog
		@blog_post.destroy
    flash[:message] = "Blog #{@blog_post.title} was destroyed."
    redirect_to(session[:return_to] || blog_named_link(nil, :index, { :blog => @blog }))
  end
	
	def pending
    @project = Blog.find(@blog_id).project # CE
    
# 		blog_show_params = params[:blog_show_params] || {}
		@pending_posts = BlogPost.paginate(:all, :conditions => ["blog_id = ? AND (is_complete = ? OR is_complete is null)", @blog_id, false], :order => "blog_posts.created_at DESC", :page => blog_show_params[:page] || 1, :per_page => 15)
		@recent_posts = recent_posts(blog_show_params)
	end
  
   def clone
    if @blog_post = @blog_post.duplicate_to(Blog.find(params[:new_blog_id]), current_user)
      flash[:notice] = 'Blog Post was successfully duplicated.'
      redirect_to([:edit, @blog_post.blog, @blog_post])
    else
      flash[:notice] = 'Unable to duplicate blog post.'
      redirect_to :back
    end
  end

	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	private
	# --------------------------------------------------------------------------------------
	# --------------------------------------------------------------------------------------
	
	def load_blog_post
		load_blog
		@blog_post = BlogPost.find(:first, :conditions => ["blog_id = ? AND (id = ? OR url_identifier = ?)", @blog_id, params[:id], params[:id]]) if params[:id]
	end
	
end
