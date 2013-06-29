class CreateCpApplicationFocusAreaAssociations < ActiveRecord::Migration
  def self.up
    create_table :cp_application_focus_area_associations do |t|
      t.integer :cp_application_id
      t.integer :focus_area_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cp_application_focus_area_associations
  end
end
