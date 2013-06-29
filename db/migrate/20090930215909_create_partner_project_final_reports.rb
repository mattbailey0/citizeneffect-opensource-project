class CreatePartnerProjectFinalReports < ActiveRecord::Migration
  def self.up
    create_table :partner_project_final_reports do |t|
      t.integer  :user_id
      t.integer  :media_album_id
      
      #construction
      t.date     :start_date
      t.date     :expected_completion_date
      t.text     :what_has_been_purchased
      t.text     :construction_job_breakdown
      t.integer  :number_of_construction_jobs_created
      t.text     :completion_summary
      
      #final budget
      t.integer  :local_currency_type_id
      t.integer  :final_cost_in_local_currency
      t.integer  :final_cost_in_usd
      
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
      
      t.timestamps
    end
  end

  def self.down
    drop_table :partner_project_final_reports
  end
end
