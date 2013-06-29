class CreateProjectFocusAreaAssociations < ActiveRecord::Migration
  def self.up
    create_table :project_focus_area_associations do |t|
      t.integer :project_id
      t.integer :focus_area_id
      t.timestamps
    end
  end

  def self.down
    drop_table :project_focus_area_associations
  end
end
