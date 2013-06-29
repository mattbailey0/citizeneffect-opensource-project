class ImportedContactEmail < ActiveMailer::Base
  belongs_to :referrer, :class_name => "User"
  belongs_to :imported_contact

  def after_initialize
    self.content_type = "text/html"
  end
  
  alias :am_send! :send!
  def send!
    self.update_attribute("rendered_email_contents", self.rendered_contents) if self.am_send!
  end
end
