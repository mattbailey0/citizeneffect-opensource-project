class CreateNewCpApplicationEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :new_cp_application_emails do |t|
      t.integer :cp_application_id
      t.text    :rendered_email_contents
      t.timestamps
    end
  end

  def self.down
    drop_table :new_cp_application_emails
  end
end
