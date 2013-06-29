class GeneralFormEmail < ActiveMailer::Base
  belongs_to :general_form

  def after_initialize
    if self.general_form.source == "DETROIT4DETROIT-2011"
      self.subject = "[Detroit4Detroit] Confirmation"
      self.sender  = "Citizen Effect <#{EMAIL_FROM_ADDRESS}>"  #may want to customize if time.
    else
      self.subject = "[Citizen Effect] Confirmation"
      self.sender  = "Citizen Effect <#{EMAIL_FROM_ADDRESS}>"
    end
    self.content_type = "text/html"
  end

  alias :am_send! :send!
  def send!
    self.update_attribute("rendered_email_contents", self.rendered_contents) if self.am_send!
  end
end

