class CreateWatchedProjectAssociations < ActiveRecord::Migration
  def self.up
    create_table :watched_project_associations do |t|
      t.integer :project_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :watched_project_associations
  end
end
