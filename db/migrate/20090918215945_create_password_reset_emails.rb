class CreatePasswordResetEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :password_reset_emails do |t|
      t.integer :user_id
      t.text    :rendered_email_contents
      t.string  :reset_password
      t.timestamps
    end
  end

  def self.down
    drop_table :password_reset_emails
  end
end
