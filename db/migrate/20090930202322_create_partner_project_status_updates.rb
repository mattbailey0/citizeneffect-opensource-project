class CreatePartnerProjectStatusUpdates < ActiveRecord::Migration
  def self.up
    create_table :partner_project_status_updates do |t|
      t.integer  :user_id
      t.integer  :media_album_id
      t.string   :title
      t.text     :field_updates
      t.timestamps
    end
  end

  def self.down
    drop_table :partner_project_status_updates
  end
end
