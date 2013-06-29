class PartnerInquiryEmail < ActiveMailer::Base
  belongs_to :partner_inquiry_form

  def after_initialize
    self.subject = "[Citizen Effect] Confirmation"
    self.sender  = "Citizen Effect <#{EMAIL_FROM_ADDRESS}>"
    self.content_type = "text/html"
  end

  alias :am_send! :send!
  def send!
    self.update_attribute("rendered_email_contents", self.rendered_contents) if self.am_send!
  end
end
