class Admin::PartnerProjectImpactReportsController < AdminController
  before_filter :get_project
  
  def index
    redirect_to([:partner_view, :admin, @project])
  end

  def show
    @partner_project_impact_report = @project.partner_project_impact_reports.find(params[:id])
    @approval = Approval.new
    @approvable_association = ApprovableAssociation.new(:approvable => @partner_project_impact_report, :approval => @approval)
    @approvable = @partner_project_impact_report
  end

  def new
    @partner_project_impact_report = @project.partner_project_impact_reports.build
  end

  def edit
    @partner_project_impact_report = @project.partner_project_impact_reports.find(params[:id])
    @project_report = @partner_project_impact_report #used for an application helper to have prettier link_tos
  end

  def create
    @partner_project_impact_report = PartnerProjectImpactReport.new(params[:partner_project_impact_report].merge({ :user => current_user, :project => @project }))

    if @partner_project_impact_report.save
      flash[:notice] = 'Partner Project Impact Report was successfully created.'
      redirect_to([:admin, @project, @partner_project_impact_report])
    else
      render :action => "new"
    end
  end

  def update
    @partner_project_impact_report = @project.partner_project_impact_reports.find(params[:id])
    
    if @partner_project_impact_report.update_attributes(params[:partner_project_impact_report])
      flash[:notice] = 'Partner Project Impact Report was successfully updated.'
      redirect_to([:admin, @project, @partner_project_impact_report])
    else
      render :action => "edit"
    end
  end

  def destroy
    @partner_project_impact_report = @project.partner_project_impact_reports.find(params[:id])
    @partner_project_impact_report.destroy
    flash[:notice] = 'Partner Project Impact Report was successfully removed.'
      
    redirect_to([:partner_view, :admin, @project])
  end
  
  private

  def get_project
    @project = Project.find(params[:project_id])
  end
end
