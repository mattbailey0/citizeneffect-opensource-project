class ImportedContact < ActiveRecord::Base
  belongs_to :user
  belongs_to :referrer, :class_name => "User"
  
  validates_uniqueness_of :email, :scope => [:referrer_id]
  
  #subject (text), personal_content (html/text)
  def send_invite_email(options)
    self.referral_code = "#{self.id}#{Time.now.to_i}"
    self.save!

    email = ImportedContactEmail.create(
                                        :referrer         => referrer,
                                        :imported_contact => self,
                                        :recipients       => [self.email],
                                        :subject          => options[:subject],
                                        :sender           => "#{referrer.display_name} <#{EMAIL_FROM_ADDRESS}>",
                                        :personal_content => options[:personal_content],
                                        :referral_code    => self.referral_code
                                        )
    email.send_later(:send!)
  end
  
  def display_name_for_import
    if self.name.blank?
      "#{self.email}"
    else
      "#{self.name} - #{self.email}"
    end
  end
  
  def name_and_email
    "#{self.name} (#{self.email})"
  end
  
end
