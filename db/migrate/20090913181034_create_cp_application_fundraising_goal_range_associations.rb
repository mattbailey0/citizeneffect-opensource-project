class CreateCpApplicationFundraisingGoalRangeAssociations < ActiveRecord::Migration
  def self.up
    create_table :cp_application_fundraising_goal_range_associations do |t|
      t.integer :cp_application_id
      t.integer :fundraising_goal_range_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cp_application_fundraising_goal_range_associations
  end
end
