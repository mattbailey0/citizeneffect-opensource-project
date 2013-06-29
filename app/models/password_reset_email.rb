class PasswordResetEmail < ActiveMailer::Base
  belongs_to :user

  def after_initialize
    self.subject = "[Citizen Effect] Password Reset"
    self.sender  = "Citizen Effect <#{EMAIL_FROM_ADDRESS}>"
  end
  
  alias :am_send! :send!
  def send!
    self.update_attribute("rendered_email_contents", self.rendered_contents) if self.am_send!
  end
end
