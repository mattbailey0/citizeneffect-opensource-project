class CreateNgoFocusAreaAssociations < ActiveRecord::Migration
  def self.up
    create_table :ngo_focus_area_associations do |t|
      t.integer :focus_area_id
      t.integer :ngo_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ngo_focus_area_associations
  end
end
