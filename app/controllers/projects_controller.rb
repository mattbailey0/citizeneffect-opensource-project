class ProjectsController < ApplicationController

  include BlogPostsControllerHelper
  
  before_filter :find_public_project, :except => [:update]
  before_filter :find_any_project, :only => [:update]
  before_filter :require_cp_for_project, :only => [:edit, :update]

  def index
  end
  
  def show
    update_recently_viewed_projects(@project)
    @blog_id = @project.blog.id
		@blog_posts = recent_posts(blog_show_params)[0, 5] # [0, 5] so we can reuse bloggity's stuff, which does 15
  end

  # GET /projects/1/edit
  def edit
  end

  # PUT /projects/1
  def update
    #TODO: only allow the social media links to be updated by removing other keys?
    
    if @project.update_attributes(params[:project])
      flash[:notice] = "Social media links successfully updated."
      redirect_to [@project, params[:return_to]]
    else
      render :action => "edit"
    end
  end

  def news_items
    @news_items = @project.news_items.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 5)
    render :update do |page|
      page << "$('#news_items .last').removeClass('last')" unless @news_items.empty?
      page.insert_html :bottom, "news_items", :partial => "shared/news_item", :collection => @news_items, :locals => { :last => @news_items.last}
    end
  end
  
  def events
    @events = @project.events.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 4)
    render :update do |page|
      page << "$('#events .last').removeClass('last')" unless @events.empty?
      page.insert_html :bottom, "events", :partial => "blog_posts/event", :collection => @events, :locals => { :last => @events.last}
    end
  end
  
  def donors
    @donations = @project.donations.paginate(:page => params[:page], :order => "created_at DESC", :per_page => 5)
    render :update do |page|
      page << "$('#project_donors .last').removeClass('last')" unless @donations.empty?
      page.insert_html :bottom, "project_donors", :partial => "projects/donor", :collection => @donations, :locals => { :last => @donations.last}
    end
  end
  
  def needing_donations
    @projects = Project.needing_donations.find(:all, :order => "approved_by_citizen_effect_at DESC")
    render :layout => false
  end
  
  def needing_a_cp
    @projects = Project.needing_a_cp.find(:all, :order => "approved_by_citizen_effect_at DESC")
    render :layout => false
  end
  
  def snapfish_card
    redirect_to @project unless @project.enable_card_donation
  end
  
  def carousel
    index = [params[:index].to_i - 1, 0].max
    scope = params[:type] == "donation" ? Project.needing_donations : Project.needing_a_cp
    @project = scope.first(:order => "approved_by_citizen_effect_at DESC", :offset => index)
    if @project
      render :action => (params[:type] == "donation" ? "needing_donations_item" : "needing_a_cp_item"), 
      :layout => false
    else
      render :text => '', :layout => false
    end
  end
  
  private
  def find_public_project
    @project = Project.user_visible_projects.find(params[:id]) if params[:id]
  end
  
  def find_any_project
    @project = Project.find(params[:id]) if params[:id]
    @project = nil unless current_user_can_edit_public_project?
  end
  
end
