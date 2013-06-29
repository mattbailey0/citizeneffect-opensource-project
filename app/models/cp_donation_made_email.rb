class CpDonationMadeEmail  < ActiveMailer::Base
  belongs_to :donation

  def after_initialize
    self.subject = "[Citizen Effect] A donation has been made to your project!"
    self.sender  = "Citizen Effect <#{EMAIL_FROM_ADDRESS}>"
    self.content_type = "text/html"
  end
  
  alias :am_send! :send!
  def send!
    self.update_attribute("rendered_email_contents", self.rendered_contents) if self.am_send!
  end
end
