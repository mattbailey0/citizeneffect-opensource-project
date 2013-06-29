class CreatePartnerProjectImpactReports < ActiveRecord::Migration
  def self.up
    create_table :partner_project_impact_reports do |t|
      t.integer  :user_id
      t.integer  :media_album_id
      
      #impact
      t.integer  :lives_directly_impacted
      t.integer  :lives_indirectly_impacted
      t.text     :primary_benefits_summary
      t.text     :extended_benefits_summary
      t.text     :education_and_nutrition
      t.text     :improved_health
      t.text     :agriculture_and_food
      t.text     :clean_energy
      
      #employment generation
      t.text     :productive_time_created
      t.integer  :number_of_jobs_created
      t.text     :job_breakdown
      t.text     :wages_increased
      t.integer  :small_businesses_created
      t.text     :business_breakdown
      t.text     :other
      
      t.text     :community_changed_summary
      
      t.timestamps
    end
  end

  def self.down
    drop_table :partner_project_impact_reports
  end
end
