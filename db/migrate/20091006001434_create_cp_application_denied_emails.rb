class CreateCpApplicationDeniedEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :cp_application_denied_emails do |t|
      t.integer :cp_application_id
      t.text    :rendered_email_contents
      t.timestamps
    end
  end

  def self.down
    drop_table :cp_application_denied_emails
  end
end
