class Api::V1::ProjectsController < ApplicationController
  before_filter :login_required
  before_filter :find_campaign
  
  def index
    if params[:user_id]
      if params[:page]
        @projects = Project.paginate(
        :per_page => 10,
        :page => params[:page],
        :conditions => {:cp_id => params[:user_id]}
        )
      else
        @projects = Project.find(
          :all,
          :conditions => {:cp_id => params[:user_id]}
        )
      end
    else
      if params[:page]
        @projects = Project.paginate(:per_page => 10, :page => params[:page] || 1)
      else
        @projects = @campaign ? @campaign.projects : Project.all
      end
    end

    respond_to do |format|
      if params[:user_id] && !User.exists?(params[:user_id])
        format.json { render :json => { :error => "User with ID #{params[:user_id]} Not Found" }, :status => 404 }
        format.xml { render :xml => "<error>User with ID #{params[:user_id]} Not Found</error>", :status => 404 }
      else
        format.json { render :action => "index" }
        format.xml  { render :action => "index" }
      end
    end
  end

  def show
    @project = Project.find_by_id(params[:id])
    @project["primary_photo_id"] = @project.primary_photo.id
    respond_to do |format|
      if params[:id].blank?
        format.json { render :json => { :error => "No ID provided" }, :status => 400 }
        format.xml { render :xml => "<error>No ID provided</error>", :status => 400 }
      elsif @project.blank?
        format.json { render :json => { :error => "Project with ID #{params[:id]} Not Found" }, :status => 404 }
        format.xml { render :xml => "<error>Project with ID #{params[:id]} Not Found</error>", :status => 404 }
      else
        format.json { render :action => "show" }
        format.xml  { render :action => "show" }
      end
    end
  end

  # {:search_term => 'Awesome', :status => 'needing_cp'}
  def search
    ids = []

    if params[:status]
      case params[:status].downcase
      when 'needing_cp'
        ids += ['6']
      when 'needing_donations'
        ids += ['7']
      when 'complete'
        ids += ProjectStatus.statuses_that_count_as_completed.map(&:id).map(&:to_s)
      else
        ids = ProjectStatus.all(:select => [:id]).map(&:id).map(&:to_s)
      end
    end

    @projects = Project.sphinx_user_visible.search(
      params[:search_term],
      :with => {:project_status_id => ids},
      :page => params[:page],
      :per_page => 10
    )

    respond_to do |format|
      if params[:search_term].blank?
        format.json { render :json => { :error => "No search term provided" }, :status => 400 }
        format.xml { render :xml => "<error>No search term provided</error>", :status => 400 }
      else
        format.json  { render :action => "search" }
        format.xml  { render :action => "search" }
      end
    end
  end
  
  private
  def find_campaign
      @campaign = Campaign.find(params[:campaign_id]) if params[:campaign_id]
  end
end

