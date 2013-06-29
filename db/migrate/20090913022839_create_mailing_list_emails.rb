class CreateMailingListEmails < ActiveRecord::Migration
  def self.up
    create_table :mailing_list_emails do |t|
      t.integer   :mailing_list_id
      t.integer   :sender_id
      t.text      :mail_contents
      t.string    :subject
      t.string    :bcc
      t.boolean   :draft, :default => true
      t.timestamp :sent_at
      t.timestamps
    end
  end

  def self.down
    drop_table :mailing_list_emails
  end
end
