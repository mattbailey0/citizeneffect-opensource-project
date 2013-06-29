class Admin::ProjectsController < AdminController
  # GET /projects
  def index
    @conditionFields = "(projects.name LIKE '%#{params[:search]}%' OR 
                          project_statuses.display_name LIKE '%#{params[:search]}%' OR 
                          partners.display_name LIKE '%#{params[:search]}%')"
    if params[:campaign] && params[:campaign] != ""
     @conditionFields += " AND campaigns.name LIKE '%#{params[:campaign]}%'"
    end
    #@projects = current_user.projects # Project.all
    @projects = current_user.projects.find(:all, 
                                  :include =>[:campaigns,:project_status,:partner],
                                  :conditions => @conditionFields,
                                  :order => "projects.id DESC")
    @projects_paginated = current_user.projects.paginate(:page => params[:page],
                                        :include =>[:campaigns,:project_status,:partner],
                                        :conditions => @conditionFields,
                                        :order => "projects.id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @donations }
      format.xls { send_as_xls }
    end
  end

  # GET /projects/1
  def show
    @project = current_user.projects.find(params[:id])
    @blog_id = @project.blog.id
  end

  def partner_view
    @project = current_user.projects.find(params[:id])
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @project = current_user.projects.find(params[:id])
  end

  # POST /projects
  def create
    params[:project][:partner_id] = current_user.partners.first.id if current_user.is_a_partner_admin?
    @project = Project.new(params[:project])
    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project proposal was successfully created.  Please fill in additional details.'
        format.html { redirect_to([:edit, :admin, @project]) } # for association editing
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = current_user.projects.find(params[:id])

    now = DateTime.now.utc
    case params[:commit]
    when "Deny"
      @project.denied_by_citizen_efect_at = now
      @project.project_status = ProjectStatus.denied
    when "Send back to Partner"
      @project.sent_back_to_partner_by_citizen_effect_at = now
      @project.project_status = ProjectStatus.needs_more_information
    when "Approve Now"
      @project.approved_by_citizen_effect_at = now
      @project.project_status = ProjectStatus.awaiting_cp
    end
    if params[:project][:project_status_id] == "7" and @project.project_status_id != 7
      @project.fundraising_start_date = now
    end
    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project proposal was successfully updated.'
        format.html { redirect_to([:admin, @project]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(admin_projects_url) }
      format.xml  { head :ok }
    end
  end

  def clone
    @project = current_user.projects.find(params[:id])

    if @project = @project.duplicate
      flash[:notice] = 'Project proposal was successfully duplicated.'
      redirect_to([:admin, @project])
    else
      flash[:notice] = 'Unable to duplicate project proposal.'
      redirect_to admin_projects_url
    end
  end
end

