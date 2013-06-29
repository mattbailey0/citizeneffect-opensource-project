class CreateGeneralFormEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :general_form_emails do |t|
      t.integer :general_form_id
      t.text    :rendered_email_contents
      t.timestamps
    end
  end

  def self.down
    drop_table :general_form_emails
  end
end
