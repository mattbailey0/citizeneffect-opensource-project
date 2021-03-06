class NewCpApplicationEmail < ActiveMailer::Base
  belongs_to :cp_application

  def after_initialize
    self.subject = "[Citizen Effect] A new CP Application has been submitted"
    self.sender  = "Citizen Effect <#{EMAIL_FROM_ADDRESS}>"
    self.recipients = ["cp@example.org"]
    self.content_type = "text/html"
  end
  
  alias :am_send! :send!
  def send!
    self.update_attribute("rendered_email_contents", self.rendered_contents) if self.am_send!
  end
end
