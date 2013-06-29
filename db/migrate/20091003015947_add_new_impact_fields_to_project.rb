class AddNewImpactFieldsToProject < ActiveRecord::Migration
  def self.up
    add_column "projects", :primary_benefits,   :text
    add_column "projects", :secondary_benefits, :text
  end

  def self.down
  end
end
