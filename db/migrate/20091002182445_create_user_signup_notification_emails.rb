class CreateUserSignupNotificationEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :user_signup_notification_emails do |t|
      t.integer :user_id
      t.text    :rendered_email_contents
      t.string  :activation_code
      t.timestamps
    end
  end

  def self.down
    drop_table :user_signup_notification_emails
  end
end
