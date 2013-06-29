class CreateUserActivationEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :user_activation_emails do |t|
      t.integer :user_id
      t.text    :rendered_email_contents
      t.timestamps
    end
  end

  def self.down
    drop_table :user_activation_emails
  end
end
