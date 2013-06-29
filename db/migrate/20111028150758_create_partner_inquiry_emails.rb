class CreatePartnerInquiryEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :partner_inquiry_emails do |t|
      t.integer :partner_inquiry_form_id
      t.text    :rendered_email_contents
      t.timestamps
    end
  end

  def self.down
    drop_table :partner_inquiry_emails
  end
end

