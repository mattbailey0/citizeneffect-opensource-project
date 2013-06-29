class AddFundraiserTypeToProjectEvent < ActiveRecord::Migration
  def self.up
    add_column "project_events", :fundraiser_type_id, :integer
  end

  def self.down
    remove_column "project_events", :fundraiser_type_id
  end
end
