class NetworkImpact < ActiveRecord::Base
  validates_presence_of :total_lives_impacted
  validates_presence_of :total_unique_donors
  validates_presence_of :total_citizen_philanthropists
  validates_presence_of :total_dollars_donated
  validates_presence_of :total_completed_projects
  validates_presence_of :total_projects_in_progress
  
  #really, somthing should be done to endsure only one "use_on_homepage" entry exists, 
  #and only one "automatically_calculated" entry exists
  
  def self.automatically_calculate_stats
    NetworkImpact.find_or_create_by_automatically_calculated(true).automatically_calculate_stats 
  end
  
  # Return false if there was a problem
  def automatically_calculate_stats
    completed_projects = Project.fundraising_completed
    self.total_lives_impacted = completed_projects.sum(:primary_lives_impacted) + 
      completed_projects.sum(:secondary_lives_impacted)
    self.total_completed_projects = completed_projects.size
    
    self.total_unique_donors = Donation.count(:email, :distinct => true)
    self.total_citizen_philanthropists = Role.cp.users.size
    self.total_dollars_donated = 
      MoneyConversion.cents_to_dollars(Donation.sum(:project_amount_in_cents, :conditions => "project_id is not null"))
    self.total_projects_in_progress = Project.needing_donations.size
    
    self.save
  end
end
