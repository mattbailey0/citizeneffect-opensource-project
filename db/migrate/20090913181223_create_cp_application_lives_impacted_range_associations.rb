class CreateCpApplicationLivesImpactedRangeAssociations < ActiveRecord::Migration
  def self.up
    create_table :cp_application_lives_impacted_range_associations do |t|
      t.integer :cp_application_id
      t.integer :lives_impacted_range_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cp_application_lives_impacted_range_associations
  end
end
