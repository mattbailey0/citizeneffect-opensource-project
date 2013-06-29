class CreateImportedContactEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :imported_contact_emails do |t|
      t.integer :referrer_id
      t.integer :imported_contact_id
      t.text    :rendered_email_contents
      t.text    :personal_content
      t.string  :referral_code
      t.timestamps
    end
  end
  
  def self.down
    drop_table :imported_contact_emails
  end
end
