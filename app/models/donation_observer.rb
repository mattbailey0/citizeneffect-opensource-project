class DonationObserver < ActiveRecord::Observer
  def after_save(donation)
#     return unless donation.project
#     return unless donation.project.project_status == ProjectStatus.fundraising
    
#     if donation.project.total_amount_raised_in_cents >= donation.project.total_cost_in_us_cents
#       donation.project.update_attributes(:project_status => ProjectStatus.planning)
#     end
  end
end
