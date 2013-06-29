class ProjectEventInvitationSentEmail < ActiveMailer::Base
  belongs_to :project_event_invitation_email
  belongs_to :event_attendance_response

  mailer_variable :user_provided_content
  mailer_variable :attendance_code
  
  def after_initialize
    self.content_type = "text/html"
  end
  
  alias :am_send! :send!
  def send!
    self.update_attribute("rendered_email_contents", self.rendered_contents) if self.am_send!
  end
end
