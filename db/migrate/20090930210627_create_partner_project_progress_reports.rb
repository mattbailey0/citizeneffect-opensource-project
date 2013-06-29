class CreatePartnerProjectProgressReports < ActiveRecord::Migration
  def self.up
    create_table :partner_project_progress_reports do |t|
      t.integer  :user_id
      t.integer  :media_album_id
      
      #construction
      t.date     :start_date
      t.date     :expected_completion_date
      t.text     :what_has_been_constructed
      t.text     :what_has_been_purchased
      t.text     :construction_job_breakdown
      t.integer  :number_of_construction_jobs_created      

      #impact
      t.integer  :lives_directly_impacted
      t.integer  :lives_indirectly_impacted
      t.text     :primary_benefits_summary
      t.text     :extended_benefits_summary
      
      t.timestamps
    end
  end

  def self.down
    drop_table :partner_project_progress_reports
  end
end
