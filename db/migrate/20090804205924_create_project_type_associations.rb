class CreateProjectTypeAssociations < ActiveRecord::Migration
  def self.up
    create_table :project_type_associations do |t|
      t.integer :project_type_id
      t.integer :project_id
      t.timestamps
    end
  end

  def self.down
    drop_table :project_type_associations
  end
end
