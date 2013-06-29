class CleanUpProjectFields < ActiveRecord::Migration
  def self.up
    Project.all.each do |p|
      report = PartnerProjectImpactReport.create(
                                              :productive_time_created => p.productive_time_created,
                                              :job_breakdown => p.jobs_created,
                                              :small_businesses_created => p.small_businesses_created,
                                              :improved_health => p.improved_health,
                                              :extended_benefits_summary => p.secondary_benificiaries,
                                              :primary_benefits_summary => p.primary_benefits + "\n" +
                                                                           p.primary_benificiaries,
                                              :other => p.income_generated + "\n" +
                                                        p.how_project_generates_income + "\n" +
                                                        p.how_project_protects_families + "\n" +
                                                        p.other_benefits
                                             )
      
      ProjectReportAssociation.create(:project_report => report, :project => p)
    end
    
    remove_column "projects", :productive_time_created
    remove_column "projects", :jobs_created
    remove_column "projects", :small_businesses_created
		remove_column "projects", :income_generated
		remove_column "projects", :improved_health
		remove_column "projects", :other_benefits
		remove_column "projects", :how_project_generates_income
		remove_column "projects", :how_project_protects_families
    remove_column "projects", :primary_benificiaries
    remove_column "projects", :secondary_benificiaries
    remove_column "projects", :primary_benefits
  end

  def self.down
  end
end
