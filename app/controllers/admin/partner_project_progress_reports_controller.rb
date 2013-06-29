class Admin::PartnerProjectProgressReportsController < AdminController
  before_filter :get_project
  
  def index
    redirect_to([:partner_view, :admin, @project])
  end
  
  def show
    @partner_project_progress_report = @project.partner_project_progress_reports.find(params[:id])
    @approval = Approval.new
    @approvable_association = ApprovableAssociation.new(:approvable => @partner_project_progress_report, :approval => @approval)
    @approvable = @partner_project_progress_report
  end
  
  def new
    @partner_project_progress_report = @project.partner_project_progress_reports.first
    @partner_project_progress_report ||= @project.partner_project_progress_reports.build

    unless @partner_project_progress_report.new_record?
      flash[:notice] = "This project already has a progress report.  Please update the existing report."
      redirect_to([:edit, :admin, @project, @partner_project_progress_report])
    end
  end
  
  def create
    @partner_project_progress_report = @project.partner_project_progress_reports.first
    @partner_project_progress_report ||= PartnerProjectProgressReport.new(params[:partner_project_progress_report].merge({ :user => current_user, :project => @project }))
    
    unless @partner_project_progress_report.new_record?
      flash[:notice] = "This project already has a progress report.  Please update the existing report."
      redirect_to([:edit, :admin, @project, @partner_project_progress_report])
      return
    end
    
    if @partner_project_progress_report.save
      flash[:notice] = 'Partner Project Progress Report was successfully created.'
      redirect_to([:admin, @project, @partner_project_progress_report])
    else
      render :action => "new"
    end
  end
  
  def edit
    @partner_project_progress_report = @project.partner_project_progress_reports.find(params[:id])
    @project_report = @partner_project_progress_report
  end
  
  def update
    @partner_project_progress_report = @project.partner_project_progress_reports.find(params[:id])
    
    if @partner_project_progress_report.update_attributes(params[:partner_project_progress_report])
      flash[:notice] = 'Partner Project Progress Report was successfully updated.'
      redirect_to([:admin, @project, @partner_project_progress_report])
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @partner_project_progress_report = @project.partner_project_progress_reports.find(params[:id])
    @partner_project_progress_report.destroy
    flash[:notice] = 'Partner Project Progress Report was successfully removed.'
      
    redirect_to([:partner_view, :admin, @project])
  end
  
  private

  def get_project
    @project = Project.find(params[:project_id])
  end  
end
