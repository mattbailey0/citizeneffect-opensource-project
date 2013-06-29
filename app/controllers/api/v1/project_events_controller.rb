class Api::V1::ProjectEventsController < ApplicationController
  before_filter :login_required
  # GET /project_events
  # GET /project_events.xml
  def index
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @project_events = @project.events
    else
      @project_events = ProjectEvent.paginate(:per_page => 10, :page => params[:page] || 1)
    end
    
    respond_to do |format|
      format.json { render :action => "index" }
      format.xml  { render :action => "index" }
    end
  end
end
