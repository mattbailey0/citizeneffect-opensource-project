class PartnerInquiryForm < ActiveRecord::Base
  #DB Fields {type: name1, name2, [..], nameN}
  #int: id
  #varchars: source, submitter_name, submitter_email, organization, organization_phone_number, organization_website, contact_name, contact_email, description
  #datetime: created_at, updated_at

  validates_presence_of :source
  validates_presence_of :submitter_name
  validates_presence_of :submitter_email
  validates_presence_of :organization

  after_create :send_email

  def display_name_for_import
    if self.submitter_name.blank?
      "#{self.submitter_email}"
    else
      "#{self.submitter_name} - #{self.submitter_email}"
    end
  end

  def name_and_email
    "#{self.submitter_name} (#{self.submitter_email})"
  end

  def send_email
    email = PartnerInquiryEmail.create(
                                       :partner_inquiry_form   => self,
                                       :recipients => [self.submitter_email],
                                       :bcc => ['']
                                       )
    email.send_later(:send!)
  end




end

