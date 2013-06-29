class CreateProjectEvents < ActiveRecord::Migration
  def self.up
    create_table :project_events do |t|
      t.integer :project_id
      t.string :host
      t.string :name
      t.string :short_description
      t.text :long_description
      t.timestamp :event_start_time
      t.timestamp :event_end_time
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.float :lat
      t.float :lng
      t.timestamps
    end
  end

  def self.down
    drop_table :project_events
  end
end
