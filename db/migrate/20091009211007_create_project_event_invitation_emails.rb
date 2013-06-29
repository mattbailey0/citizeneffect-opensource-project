class CreateProjectEventInvitationEmails < ActiveRecord::Migration
  def self.up
    create_table :project_event_invitation_emails do |t|
      t.integer   :project_event_id
      t.integer   :sender_id
      t.text      :mail_contents
      t.string    :subject
      t.boolean   :draft, :default => true
      t.timestamp :sent_at
      t.timestamps
    end
  end

  def self.down
    drop_table :project_event_invitation_emails
  end
end
