class Admin::ProjectTypeAssociationsController < AdminController
  
  before_filter :find_project
  
  # GET /project_type_associations
  # GET /project_type_associations.xml
  def index
    @project_type_associations = @project.project_type_associations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @project_type_associations }
    end
  end

  # GET /project_type_associations/1
  # GET /project_type_associations/1.xml
  def show
    @project_type_association = @project.project_type_associations.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project_type_association }
    end
  end

  # GET /project_type_associations/new
  # GET /project_type_associations/new.xml
  def new
    @project_type_association = @project.project_type_associations.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project_type_association }
    end
  end

  # GET /project_type_associations/1/edit
  def edit
    @project_type_association = @project.project_type_associations.find(params[:id])
  end

  # POST /project_type_associations
  # POST /project_type_associations.xml
  def create
    @project_type_association = @project.project_type_associations.build(params[:project_type_association])

    respond_to do |format|
      if @project_type_association.save
        flash[:notice] = 'ProjectTypeAssociation was successfully created.'
        format.html { redirect_to([:admin, @project, @project_type_association]) }
        format.xml  { render :xml => @project_type_association, :status => :created, :location => @project_type_association }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project_type_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_type_associations/1
  # PUT /project_type_associations/1.xml
  def update
    @project_type_association = @project.project_type_associations.find(params[:id])

    respond_to do |format|
      if @project_type_association.update_attributes(params[:project_type_association])
        flash[:notice] = 'ProjectTypeAssociation was successfully updated.'
        format.html { redirect_to([:admin, @project, @project_type_association]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project_type_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_type_associations/1
  # DELETE /project_type_associations/1.xml
  def destroy
    @project_type_association = @project.project_type_associations.find(params[:id])
    @project_type_association.destroy

    respond_to do |format|
      format.html { redirect_to(admin_project_project_type_associations_url(@project)) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
end
