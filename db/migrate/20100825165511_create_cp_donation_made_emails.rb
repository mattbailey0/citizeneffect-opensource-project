class CreateCpDonationMadeEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :cp_donation_made_emails do |t|
      t.integer :donation_id
      t.text    :rendered_email_contents
      t.timestamps
    end
  end

  def self.down
    drop_table :cp_donation_made_emails
  end
end
