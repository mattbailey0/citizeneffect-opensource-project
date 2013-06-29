class MailingListEmail < ActiveRecord::Base
  belongs_to :mailing_list
  belongs_to :sender, :class_name => "User"
  has_many   :mailing_list_send_emails
  has_many_unified_attachments :email_attachments
  
  validates_presence_of :mail_contents, :subject, :unless => :draft
  validates_presence_of :sender_id
  validates_presence_of :mailing_list_id
  
  accepts_nested_attributes_for :email_attachments, :allow_destroy => true
  
  def send!(force = false)
    return true  unless self.draft or force
    return false unless self.update_attributes(:draft => false)
    
    self.send_later(:send_now!)
  end
  
  def send_now!(force = false)
    return false unless self.update_attributes(:draft => false)
    return true if self.sent_at and !force
    
    self.update_attribute("sent_at", Time.now)
    
    send_to_subscribers! unless self.mailing_list.subscribers.blank?
    send_to_bcc! unless self.bcc.blank?
  end

  def send_to_subscribers!
    sender = "#{self.sender.first_name} #{self.sender.last_name} <#{EMAIL_FROM_ADDRESS}>"
    
    self.mailing_list.subscribers.each do |subscriber|
      mlse = MailingListSentEmail.new(
                                      :mailing_list_email_id => self.id,
                                      :recipients            => [subscriber.email],
                                      :subject               => self.subject,
                                      :sender                => sender,
                                      :user_provided_content => self.mail_contents,
                                      :unsubscribe_token     => subscriber.unsubscribe_token,
                                      :attachments           => self.email_attachments
                                      )
      mlse.send!
    end
  end
  private :send_to_subscribers!
  
  # is bcc an array of comma separated emails?
  def send_to_bcc!
    sender = "#{self.sender.first_name} #{self.sender.last_name} <#{EMAIL_FROM_ADDRESS}>"
    emails = self.bcc.split(/[, ]/).map(&:strip).map(&:downcase).reject(&:blank?)

    emails.each do |email|
      mlse = MailingListSentEmail.new(
                                      :mailing_list_email_id => self.id,
                                      :recipients            => [email],
                                      :subject               => self.subject,
                                      :sender                => sender,
                                      :user_provided_content => self.mail_contents,
                                      :attachments           => self.email_attachments
                                    )
      mlse.send!
    end
  end
  private :send_to_bcc!
  
end
