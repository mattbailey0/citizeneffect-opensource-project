class ProjectEventInvitationEmail < ActiveRecord::Base
  belongs_to :project_event
  belongs_to :sender, :class_name => "User"
  has_many   :event_attendance_responses, :autosave => true
  has_many   :project_event_invitation_sent_emails
  
  validates_presence_of :mail_contents, :subject
  validates_presence_of :project_event_id
  validates_presence_of :sender_id
  
  before_save :build_attendance_responses
  
  @email_list
  @imported_contact_ids
  
  def event_information_text
    "You've been invited to the #{self.project_event.name} supporting #{self.project_event.project.name} on #{self.project_event.event_start_time.to_date.to_s(:long)}."
  end
  
  def event_information_link_text
    "Click here to read event details, location and RSVP!"
  end
    
  def send!(force = false)
    return true  unless self.draft or force
    return false unless self.update_attributes(:draft => false)
    
    self.send_later(:send_now!)
  end
  
  def send_now!(force = false)
    return false unless self.update_attributes(:draft => false)
    return true if self.sent_at and !force
    
    self.update_attribute("sent_at", Time.now)
    send_to_invitees! unless self.event_attendance_responses.blank?
  end
  
  def send_to_invitees!
    sender = "#{self.sender.first_name} #{self.sender.last_name} <#{EMAIL_FROM_ADDRESS}>"
    self.event_attendance_responses.each do |invitee|
      peise = ProjectEventInvitationSentEmail.new(
                                                  :project_event_invitation_email => self,
                                                  :event_attendance_response      => invitee,
                                                  :recipients                     => [invitee.email],
                                                  :subject                        => self.subject,
                                                  :sender                         => sender,
                                                  :user_provided_content          => self.mail_contents,
                                                  :attendance_code                => invitee.attendance_code
                                                  )
      peise.send!
    end
  end

  def to
    if(@email_list)
      @email_list
    else
      self.event_attendance_responses.find(:all, 
                                      :conditions => "imported_contact_id is null").map(&:email).join(", ")
    end
  end
  
  def to=(emails)
    raise "No longer a draft" unless self.draft
    @email_list = emails
    self.updated_at_will_change! #cause we need the save callback to run
  end
  
  def imported_contact_ids
    if(@imported_contact_ids)
      @imported_contact_ids
    else
      self.event_attendance_responses.find(:all, 
                                      :conditions => "imported_contact_id is not null").map(&:imported_contact_id)
    end
  end
  
  def imported_contact_ids=(contact_ids)
    raise "No longer a draft" unless self.draft
    @imported_contact_ids = contact_ids.reject(&:blank?)
    self.updated_at_will_change! #cause we need the save callback to run
  end
  
  def build_attendance_responses
    return true unless self.draft
    
    self.event_attendance_responses.each { |r| r.mark_for_destruction }
    self.event_attendance_responses.clear
    
    
    self.build_attendance_responses_for_email_list unless @email_list.nil?
    self.build_attendance_responses_for_contacts   unless @imported_contact_ids.nil?
    
    true
  end
  
  def build_attendance_responses_for_email_list
    emails = @email_list.split(/[, ]/).map(&:strip).map(&:downcase).reject(&:blank?)
    
    emails.each do |email|
      self.find_or_create_response(:email => email)
    end
    
    @email_list = nil
  end
  
  def build_attendance_responses_for_contacts
    @imported_contact_ids.each do |contact_id|
      contact = ImportedContact.find(contact_id)
      self.find_or_create_response(:email => contact.email, :contact => contact)
    end
    
    @imported_contact_ids = nil
  end
  
  def find_or_create_response(options)
    response = EventAttendanceResponse.new(
                                           :project_event                  => project_event,
                                           :email                          => options[:email],
                                           :imported_contact               => options[:contact],
                                           :project_event_invitation_email => self
                                           )
    
    self.event_attendance_responses << response
  end
  
end
