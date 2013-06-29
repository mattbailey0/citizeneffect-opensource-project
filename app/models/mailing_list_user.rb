class MailingListUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :mailing_list
  
  validates_presence_of   :email
  validates_uniqueness_of :email,   :scope => [:mailing_list_id]
  validates_uniqueness_of :user_id, :scope => [:mailing_list_id], :allow_nil => true
  validates_presence_of   :zip, :if => Proc.new { |m| !m.tracking_code.blank? }
  
  before_create :generate_unsubscribe_token
  before_validation :associate_with_user
  
  def generate_unsubscribe_token
    self.unsubscribe_token = Digest::MD5.hexdigest("aoijfsdk--#{self.email}#{Time.now}#{self.mailing_list.id}")
  end
  
  def associate_with_user
    self.user ||= User.find_by_email(self.email)
  end
  
  def zip
    self.user.andand.zip || read_attribute("zip")
  end
  
  def email
    self.user.andand.email || read_attribute("email")
  end
  
  def first_name
    self.user.andand.first_name || read_attribute("first_name")
  end
  
  def last_name
    self.user.andand.last_name || read_attribute("last_name")
  end


end
