class PartnerProjectStatusUpdatesController < ApplicationController
  before_filter :get_project

  def show
    @partner_project_status_update = @project.partner_project_status_updates.find(params[:id])
  end

  private

  def get_project
    @project = Project.find(params[:project_id])
  end
end
