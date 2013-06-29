class ProjectEventsController < ApplicationController
  before_filter :find_project
  before_filter :require_cp_for_project, :except => [:show, :index]

  # GET /project_events
  def index
    redirect_to @project
  end

  # GET /project_events/1
  def show
    @project_event = @project.events.find(params[:id])
    @event_attendance_response =
      if !params[:attendance_code].blank?
        @project_event.event_attendance_responses.find_by_attendance_code(params[:attendance_code])
      elsif logged_in?
        @event_attendance_response ||= @project_event.event_attendance_responses.find_by_user_id(current_user.id)
      end
    respond_to do |format|
      format.html { render :action => "show" }
      format.ics { render :text => @project_event.to_ics(project_project_event_url(@project, @project_event), params[:outlook] ? true : false) }

    end
  end

  # GET /project_events/new
  def new
    @project_event = @project.events.build
  end

  # GET /project_events/1/edit
  def share
    @project_event = @project.events.find(params[:id])
  end

  # GET /project_events/1/edit
  def edit
    @project_event = @project.events.find(params[:id])
  end

  # POST /project_events
  def create
    @project_event = @project.events.build(params[:project_event])
    if @project_event.host.blank?
      if @project_event.project.andand.cp.andand.name
        @project_event.host = @project_event.project.cp.name
      else
        @project_event.host = "No Host"
      end
    end
    if @project_event.save
      flash[:notice] = 'Fundraiser Created.'
      redirect_to([@project, @project_event])
    else
      render :action => "new"
    end
  end

  # PUT /project_events/1
  def update
    @project_event = @project.events.find(params[:id])

    if @project_event.update_attributes(params[:project_event])
      flash[:notice] = 'Fundraiser Updated.'
      redirect_to([@project,@project_event])
    else
      render :action => "edit"
    end
  end

  # DELETE /project_events/1
  def destroy
    @project_event = @project.events.find(params[:id])
    @project_event.destroy
    flash[:notice] = "Fundraiser Removed"

    redirect_to @project
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

end

