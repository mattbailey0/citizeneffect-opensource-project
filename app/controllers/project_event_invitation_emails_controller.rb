class ProjectEventInvitationEmailsController < ApplicationController
  
  before_filter :find_project_event
  before_filter :require_cp_for_project
  
  # GET /project_event_invitation_emails
  def index
    redirect_to [:new, @project_event, :project_event_invitation_email]
  end
  
  # GET /project_event_invitation_emails/new
  def new
    @project_event_invitation_email = @project_event.project_event_invitation_emails.build
  end

  # POST /project_event_invitation_emails
  def create
#     params[:project_event_invitation_email][:to] += ',' + params[:emails_from_popup]
    
    @project_event_invitation_email = @project_event.project_event_invitation_emails.build(params[:project_event_invitation_email])
    @project_event_invitation_email.sender = current_user

    if @project_event_invitation_email.save && @project_event_invitation_email.send!
      invitee_size = @project_event_invitation_email.event_attendance_responses.size
      flash[:notice] = %Q{#{invitee_size} #{invitee_size != 1 ? 'people' : 'person'} invited to '#{CGI.escapeHTML @project_event.name}'.}
      redirect_to([@project_event.project, @project_event])
    else
      render :action => "new"
    end
  end

  private
  
  def find_project_event
    @project_event = ProjectEvent.find(params[:project_event_id])
    @project = @project_event.project
  end
  
end
