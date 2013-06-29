class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :ngo_id

      # 1Well Admins
      t.string    :state
      t.timestamp :state_updated_at
      t.string    :next_step
      t.date      :due_on
      t.string    :whats_missing
      t.string    :why_denied
      t.timestamp :project_created_at
      t.timestamp :approved_by_1well_at
      t.timestamp :sent_back_to_ngo_by_1well_at
      t.timestamp :denied_by_1well_at
      t.string    :permalink
      
      # Project Dates
      t.date :estimated_construction_start_date
      t.date :actual_construction_start_date
      t.date :estimted_construction_completed_date
      t.date :actual_construction_completed_date
      
      # General Details - unlabeled on form
      t.string  :name
      t.string  :priority
      t.text    :primary_objective
      t.date    :desired_construction_start_date
      
      # Personnel Details
      t.string  :district_coordinator
      t.string  :community_leader
      
      # Budget Details
      t.integer :total_cost_in_local_currency
      t.integer :local_currency_type_id
      t.integer :total_cost_in_usd
      
      # attach detailed project budget
      t.string  :detailed_project_budget_file_name
      t.string  :detailed_project_budget_content_type
      t.string  :detailed_project_budget_file_size
      t.string  :detailed_project_budget_updated_at

      # Location and Impact Stats
      t.string  :community_name
      t.string  :district_name
      t.string  :community_state
      t.integer :country_id
      t.integer :community_population
      t.integer :primary_lives_impacted
      t.integer :secondary_lives_impacted

      # Community Details
      t.text    :community_summary_for_website
      t.text    :major_communities
      t.text    :major_occupations
      t.integer :average_income_per_household
      t.integer :families_living_below_poverty
      t.text    :brief_history_of_community
      t.text    :weather
      t.text    :major_issues
      
      # Project Details
      t.text :summary_for_website
      t.text :justification_for_project
      t.text :what_will_be_done
      t.text :how_will_it_be_done
      
      # Sustainability
      t.text :environmental_sustainability
      t.text :economic_sustainability
      t.text :social_sustainability
      
      # Project Impact Details
      t.text :primary_benificiaries
      t.text :secondary_benificiaries
      t.text :primary_benefits
      
      # Secondary Benefits
      t.text :productive_time_created
      t.text :jobs_created
      t.text :small_businesses_created
      t.text :income_generated
      t.text :improved_health
      t.text :other_benefits
      t.text :how_project_generates_income
      t.text :how_project_protects_families
      
      # Timeline
      t.text :proposed_timeline
      
      # Community Characteristic Details
      t.text :agricultural_land
      t.text :animal_husbandry
      t.text :water_related_infrastructure
      t.text :sanitation
      t.text :healthcare_facilities
      t.text :transportation
      t.text :commerce
      t.text :education
      
      
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
