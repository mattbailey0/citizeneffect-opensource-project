class CreateNgoCoordinatorAssociations < ActiveRecord::Migration
  def self.up
    create_table :ngo_coordinator_associations do |t|
      t.integer :user_id
      t.integer :project_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ngo_coordinator_associations
  end
end
