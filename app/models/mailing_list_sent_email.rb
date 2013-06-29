class MailingListSentEmail < ActiveMailer::Base
  belongs_to :mailing_list_email

  mailer_variable :user_provided_content
  mailer_variable :unsubscribe_token
  
  def after_initialize
    self.content_type = "text/html"
  end
  
  alias :am_send! :send!
  def send!
    self.update_attribute("rendered_email_contents", self.rendered_contents) if self.am_send!
  end
end

