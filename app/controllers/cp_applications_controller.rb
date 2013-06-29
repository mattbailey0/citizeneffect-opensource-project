class CpApplicationsController < ApplicationController
  before_filter :get_project

  # GET /cp_applications
  def index
    redirect_to @project ? [:new, @project, :cp_application] : new_cp_application_path
  end

  # GET /cp_applications/new
  def new
    unless current_user
      flash[:notice] = "In order to apply to be a citizen philanthropist, please create an account."
      redirect_to signup_path
    else
      @cp_application = CpApplication.new(:user => current_user, :project => @project)
      build_associations_if_necessary
      render :action => "new"
    end 
  end

  # POST /cp_applications
  def create
    @cp_application = CpApplication.new(:user => current_user)
    @cp_application.update_attributes(params[:cp_application])
    @project ||= @cp_application.project
    
    if @cp_application.save
      flash[:notice] = 'Your CP Application has been submitted'
      render :action => "cp_application_complete"
    else
      build_associations_if_necessary
      render :action => "new"
    end
  end

  private
  
  def build_associations_if_necessary
    @cp_application.build_cp_application_lives_impacted_range_association unless @cp_application.cp_application_lives_impacted_range_association
    @cp_application.build_cp_application_fundraising_goal_range_association unless @cp_application.cp_application_fundraising_goal_range_association
  end
  
  def get_project
    @project = Project.find(params[:project_id]) if params[:project_id]
  end
  
end
