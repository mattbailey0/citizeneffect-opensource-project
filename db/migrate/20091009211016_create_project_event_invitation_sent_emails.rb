class CreateProjectEventInvitationSentEmails < ActiveRecord::Migration
  def self.up
    create_active_mailer_table :project_event_invitation_sent_emails do |t|
      t.integer :project_event_invitation_email_id
      t.integer :event_attendance_response_id
      t.text    :rendered_email_contents
      t.timestamps
    end
  end

  def self.down
    drop_table :project_event_invitation_sent_emails
  end
end
