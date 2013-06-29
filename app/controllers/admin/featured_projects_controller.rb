class Admin::FeaturedProjectsController < AdminController
  # GET /featured_projects
  # GET /featured_projects.xml
  def index
    @featured_projects = FeaturedProject.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @featured_projects }
      format.xls { send_as_xls }
    end
  end

  # GET /featured_projects/1
  # GET /featured_projects/1.xml
  def show
    @featured_project = FeaturedProject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @featured_project }
    end
  end

  # GET /featured_projects/new
  # GET /featured_projects/new.xml
  def new
    @featured_project = FeaturedProject.new
    @featured_project.build_picture unless @featured_project.picture
    @featured_project.build_picture_thumbnail unless @featured_project.picture_thumbnail
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @featured_project }
    end
  end

  # GET /featured_projects/1/edit
  def edit
    @featured_project = FeaturedProject.find(params[:id])
    @featured_project.build_picture_thumbnail unless @featured_project.picture_thumbnail
  end

  # POST /featured_projects
  # POST /featured_projects.xml
  def create
    @featured_project = FeaturedProject.new(params[:featured_project])

    respond_to do |format|
      if @featured_project.save
        flash[:notice] = 'Featured Project was successfully added.'
        format.html { redirect_to(admin_featured_projects_path) }
        format.xml  { render :xml => @featured_project, :status => :created, :location => @featured_project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @featured_project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /featured_projects/1
  # PUT /featured_projects/1.xml
  def update
    @featured_project = FeaturedProject.find(params[:id])

    respond_to do |format|
      if @featured_project.update_attributes(params[:featured_project])
        flash[:notice] = 'Featured Project was successfully updated.'
        format.html { redirect_to(admin_featured_projects_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @featured_project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /featured_projects/1
  # DELETE /featured_projects/1.xml
  def destroy
    @featured_project = FeaturedProject.find(params[:id])
    @featured_project.destroy
    flash[:notice] = "Featured Project was successfully removed."
    respond_to do |format|
      format.html { redirect_to(admin_featured_projects_url) }
      format.xml  { head :ok }
    end
  end
  
  def move_higher
    @featured_project = FeaturedProject.find(params[:id])
    @featured_project.move_higher
    redirect_to(admin_featured_projects_url)
  end
  
  def move_lower
    @featured_project = FeaturedProject.find(params[:id])
    @featured_project.move_lower
    redirect_to(admin_featured_projects_url)
  end
end
