class CreateMailingListSentEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :mailing_list_sent_emails do |t|
      t.integer :mailing_list_email_id
      t.text    :rendered_email_contents
      t.timestamps
    end
  end

  def self.down
    drop_table :mailing_list_sent_emails
  end
end
