class PartnerProjectProgressReportsController < ApplicationController
  before_filter :get_project

  def show
    @partner_project_progress_report = @project.partner_project_progress_reports.find(params[:id])
  end

  private

  def get_project
    @project = Project.find(params[:project_id])
  end
end
