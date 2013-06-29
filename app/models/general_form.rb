class GeneralForm < ActiveRecord::Base
  #these lines can be combined [..]_of :source, :first_name, ...
  validates_presence_of :source             #must be present
  validates_presence_of :first_name         #must be present
  validates_presence_of :last_name          #msut be present
  validates_presence_of :email              #must be present, have one @ and at least one ., (must pass regex)
  #validates_presence_of :phone_number       #regex?

  #validates_length_of  for all fields?
  #EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #EmailRegex = \b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b
  #validates_format_of :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false

  # validates_presence_of :location
  # validates_presence_of :location_other
  # validates_presence_of :cause
  # validates_presence_of :referred_by
  # validates_presence_of :comment
  # validates_presence_of :request

  after_create :send_email

  def display_name_for_import
    if self.first_name.blank?
      "#{self.email}"
    else
      "#{self.first_name} #{self.last_name} - #{self.email}"
    end
  end

  def name_and_email
    "#{self.first_name} #{self.last_name} (#{self.email})"
  end

  def send_email
      email = GeneralFormEmail.create(
                                       :general_form   => self,
                                       :recipients => [self.email]
                                       )
      email.send_later(:send!)
  end

end

