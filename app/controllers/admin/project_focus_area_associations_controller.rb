class Admin::ProjectFocusAreaAssociationsController < AdminController
  
  before_filter :find_project
  
  # GET /project_focus_area_associations
  # GET /project_focus_area_associations.xml
  def index
    @project_focus_area_associations = @project.project_focus_area_associations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_focus_area_associations }
    end
  end

  # GET /project_focus_area_associations/1
  # GET /project_focus_area_associations/1.xml
  def show
    @project_focus_area_association = @project.project_focus_area_associations.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_focus_area_association }
    end
  end

  # GET /project_focus_area_associations/new
  # GET /project_focus_area_associations/new.xml
  def new
    @project_focus_area_association = @project.project_focus_area_associations.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_focus_area_association }
    end
  end

  # GET /project_focus_area_associations/1/edit
  def edit
    @project_focus_area_association = @project.project_focus_area_associations.find(params[:id])
  end

  # POST /project_focus_area_associations
  # POST /project_focus_area_associations.xml
  def create
    @project_focus_area_association = @project.project_focus_area_associations.build(params[:project_focus_area_association])

    respond_to do |format|
      if @project_focus_area_association.save
        flash[:notice] = 'ProjectFocusAreaAssociation was successfully created.'
        format.html { redirect_to([:admin, @project, @project_focus_area_association]) }
        format.xml  { render :xml => @project_focus_area_association, :status => :created, :location => @project_focus_area_association }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_focus_area_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_focus_area_associations/1
  # PUT /project_focus_area_associations/1.xml
  def update
    @project_focus_area_association = @project.project_focus_area_associations.find(params[:id])

    respond_to do |format|
      if @project_focus_area_association.update_attributes(params[:project_focus_area_association])
        flash[:notice] = 'ProjectFocusAreaAssociation was successfully updated.'
        format.html { redirect_to([:admin, @project, @project_focus_area_association]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_focus_area_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_focus_area_associations/1
  # DELETE /project_focus_area_associations/1.xml
  def destroy
    @project_focus_area_association = @project.project_focus_area_associations.find(params[:id])
    @project_focus_area_association.destroy

    respond_to do |format|
      format.html { redirect_to(admin_project_project_focus_area_associations_url(@project)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
end
