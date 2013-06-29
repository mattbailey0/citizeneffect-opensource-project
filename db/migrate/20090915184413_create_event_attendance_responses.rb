class CreateEventAttendanceResponses < ActiveRecord::Migration
  def self.up
    create_table :event_attendance_responses do |t|
      t.integer :imported_contact_id
      t.integer :user_id
      t.integer :project_event_id
      t.integer :project_event_invitation_email_id
      t.string  :attendance_code
      t.string  :email
      t.integer :response
      t.timestamps
    end
  end

  def self.down
    drop_table :event_attendance_responses
  end
end
