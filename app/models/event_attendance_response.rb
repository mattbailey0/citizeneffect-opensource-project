class EventAttendanceResponse < ActiveRecord::Base
  NO_RESPONSE = nil
  NO          = 1
  MAYBE       = 2
  YES         = 3
  
  RESPONSES = [NO_RESPONSE, NO, MAYBE, YES]
  VALID_CUSTOMER_RESPONSES = [YES, MAYBE, NO]
  RESPONSE_TEXT = {
    NO_RESPONSE => "Hasn't Responded",
    NO          => "Not Attending",
    MAYBE       => "Maybe Attending",
    YES         => "Attending",
  }
  
  belongs_to :project_event_invitation_email
  belongs_to :project_event
  belongs_to :imported_contact
  belongs_to :user
  
  named_scope :yes,   :conditions => { :response => YES}
  named_scope :no,    :conditions => { :response => NO}
  named_scope :maybe, :conditions => { :response => MAYBE}
  named_scope :valid_customer_responses, :conditions => { :response => VALID_CUSTOMER_RESPONSES }
  
  validates_presence_of   :project_event
  validates_presence_of   :project_event_invitation_email
  validates_presence_of   :email
#   validates_uniqueness_of :email, :scope => [:project_event_id]
  validates_inclusion_of  :response, :in => RESPONSES
  
  before_create :generate_attendance_code, :get_email_address, :get_user
  
  def generate_attendance_code
    self.attendance_code = Digest::MD5.hexdigest("aoijfsdk--#{self.email}#{Time.now}#{self.project_event.id}")
  end
  
  def get_user
    return if self.user
    self.user = self.imported_contact.andand.user
    unless self.user
      self.user = User.find_by_email(self.email)
    end
  end

  def get_email_address
    if self.email.blank? && self.imported_contact
      self.email = self.imported_contact.email
    end
  end

end
