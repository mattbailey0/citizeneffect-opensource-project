class PartnerProjectFinalReportsController < ApplicationController
  before_filter :get_project

  def show
    @partner_project_final_report = @project.partner_project_final_reports.find(params[:id])
  end

  private

  def get_project
    @project = Project.find(params[:project_id])
  end
end
