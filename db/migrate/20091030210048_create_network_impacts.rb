class CreateNetworkImpacts < ActiveRecord::Migration
  def self.up
    create_table :network_impacts do |t|
      t.boolean :use_on_homepage, :default => false
      t.boolean :automatically_calculated, :default => false
      t.integer :total_lives_impacted, :default => 0
      t.integer :total_unique_donors, :default => 0
      t.integer :total_citizen_philanthropists, :default => 0
      t.integer :total_dollars_donated, :default => 0
      t.integer :total_completed_projects, :default => 0
      t.integer :total_projects_in_progress, :default => 0

      t.timestamps
    end
    
    NetworkImpact.reset_column_information
    
    NetworkImpact.create({
      :use_on_homepage => true,
      :automatically_calculated => true,
      :total_lives_impacted => 31598,
      :total_unique_donors => 674,
      :total_citizen_philanthropists => 45,
      :total_dollars_donated => 25000,
      :total_completed_projects => 129,
      :total_projects_in_progress => 21
    })
    
    NetworkImpact.create({
      :use_on_homepage => false,
      :automatically_calculated => false,
      :total_lives_impacted => 31598,
      :total_unique_donors => 674,
      :total_citizen_philanthropists => 45,
      :total_dollars_donated => 25000,
      :total_completed_projects => 129,
      :total_projects_in_progress => 21
    })
  end

  def self.down
    drop_table :network_impacts
  end
end
