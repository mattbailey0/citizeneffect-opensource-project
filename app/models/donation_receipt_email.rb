class DonationReceiptEmail < ActiveMailer::Base
  belongs_to :donation
  
  def after_initialize
    self.subject = "[Citizen Effect] Thank You For Your Donation!"
    self.sender  = "Citizen Effect <#{EMAIL_FROM_ADDRESS}>"
    self.bcc = ["info@example.org"]
  end
  
  alias :am_send! :send!
  def send!
    self.update_attribute("rendered_email_contents", self.rendered_contents) if self.am_send!
  end
end
