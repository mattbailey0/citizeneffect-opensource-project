class Admin::PartnerProjectStatusUpdatesController < AdminController
  before_filter :get_project
  
  def index
    redirect_to([:partner_view, :admin, @project])
  end

  def show
    @partner_project_status_update = @project.partner_project_status_updates.find(params[:id])
  end

  def new
    @partner_project_status_update = @project.partner_project_status_updates.build
  end

  def edit
    @partner_project_status_update = @project.partner_project_status_updates.find(params[:id])
    @project_report = @partner_project_status_update #used for an application helper to have prettier link_tos
  end

  def create
    @partner_project_status_update = PartnerProjectStatusUpdate.new(params[:partner_project_status_update].merge({ :user => current_user, :project => @project }))

    if @partner_project_status_update.save
      flash[:notice] = 'Partner Project Status Update was successfully created.'
      redirect_to([:admin, @project, @partner_project_status_update])
    else
      render :action => "new"
    end
  end

  def update
    @partner_project_status_update = @project.partner_project_status_updates.find(params[:id])
    
    if @partner_project_status_update.update_attributes(params[:partner_project_status_update])
      flash[:notice] = 'Partner Project Status Update was successfully updated.'
      redirect_to([:admin, @project, @partner_project_status_update])
    else
      render :action => "edit"
    end
  end

  def destroy
    @partner_project_status_update = @project.partner_project_status_updates.find(params[:id])
    @partner_project_status_update.destroy
    flash[:notice] = 'Partner Project Status Update was successfully removed.'
      
    redirect_to([:partner_view, :admin, @project])
  end
  
  private

  def get_project
    @project = Project.find(params[:project_id])
  end
end
