When /^I go to the "([^\"]*)" project page$/ do |name|
  $browser.goto @host + project_path(Project.find_by_name(name))
  assert_successful_response
end

Given /^there is a featured project$/ do
  Factory.create(:featured_project, :title => "Featured Farm Project")
end

Given /^there is a project with name "([^\"]*)"$/ do |name|
  @recent_project = Factory.create(:project, :name => name)
end

Given /^there is a project named "([^\"]*)"$/ do |name|
  Given "there is a project with name \"#{name}\""
end


Given /^there is a user visible project with name "([^\"]*)"$/ do |name|
  @recent_project = Factory.create(:project, :name => name, :project_status => ProjectStatus.awaiting_cp)
end

When /^I view that project$/ do
  When "I go to the \"#{@recent_project.name}\" project page"
end

Given /^that project is on my watchlist$/ do
  @recent_user.watched_projects << @recent_project
end

Then /^I should see an image link for that project with class "([^\"]*)"$/ do |klass|
  @recent_image_link_class = "#{klass}_#{@recent_project.id}"
  Then "I should see an image link with class \"#{@recent_image_link_class}\""
end

When /^I follow that image link$/ do
  When "I follow an image link with class \"#{@recent_image_link_class}\""
end

Then /^I should not see the name of that project in my watchlist$/ do
  Then "I should not see \"#{@recent_project.name}\" in class \"user_watchlist\""
end

Given /^there is at least one Project on the homepage$/ do
  Given "there is a user visible project with name \"Test Project\""
end

Given /^there is a project$/ do
  @recent_project = Factory.create(:project)
  Given "that project is user visible"
end

Given /^that there is a project$/ do
  Given "there is a project"
end

Given /^that project has a CP named "([^\"]*)"$/ do |cp_name|
  @recent_user ||= Given "there is a user named \"#{cp_name}\""
  @recent_user.roles.add!(Role.cp)
  @recent_user.roles(true) # add! make the association directly
  @recent_project.update_attributes!(:cp => @recent_user)
end

Given /^that project is in the Country "([^\"]*)"$/ do |country_name|
  Given "there is a country named \"#{country_name}\""
  @recent_project.update_attributes!(:country => @recent_country)
end

Given /^that project has Primary Lives Impacted "([^\"]*)"$/ do |number_of_lives|
  @recent_project.update_attributes!(:primary_lives_impacted => number_of_lives.to_i)
end

Given /^that project has Focus Area "([^\"]*)"$/ do |focus_area_name|
  focus_area = FocusArea.find_by_name(focus_area_name)
  focus_area ||= Factory.create(:focus_area, :name => focus_area_name)
  @recent_project.focus_areas << focus_area
end

Given /^that project has a total cost of "([^\"]*)" dollars$/ do |cost|
  @recent_project.total_cost_in_usd = cost.to_i
  @recent_project.save!
end

Given /^that project is user visible$/ do 
  @recent_project.update_attributes!(:project_status => ProjectStatus.awaiting_cp)
end


Given /^that project is completed$/ do
  Given "that project has status \"Planning\""
end

Then /^I should see the name of that project$/ do
  Then "I should see \"#{@recent_project.name}\""  
end

Then /^I should see the name of that project in all caps$/ do
  Then "I should see \"#{@recent_project.name.upcase}\""  
end

Given /^that project has a CP$/ do
  @recent_project.cp = Factory.create("cp") unless(@recent_project.cp)
  @recent_project.save!
end

Given /^that project has primary lives impacted set to "([^\"]*)"$/ do |lives_impacted|
  @recent_project.update_attributes!(:primary_lives_impacted => lives_impacted.to_i)
end

Given /^that project has secondary lives impacted set to "([^\"]*)"$/ do |lives_impacted|
  @recent_project.update_attributes!(:secondary_lives_impacted => lives_impacted.to_i)
end

Given /^that project has a total donation amount of "([^\"]*)" dollars$/ do |donation_amount|
  amount = (donation_amount.to_f*100).to_i
  @recent_project.total_cost_in_us_cents = [@recent_project.total_cost_in_us_cents, amount+1].max
  amount = amount - @recent_project.total_amount_raised_in_cents
  Factory.create(:donation, 
                 :project => @recent_project, 
                 :amount_in_cents => amount,
                 :offline => true,
                 :donation_cp => @recent_project.cp)
end

Given /^that project has an event$/ do
  @recent_event = Factory.create(:project_event, :project => @recent_project)
end

Given /^that project has one offline donation$/ do
  @recent_donation = Factory.create(:donation, 
                                    :project => @recent_project, 
                                    :offline => true,
                                    :donation_cp => @recent_project.cp)
end

Given /^that project has lives impacted of "([^\"]*)"$/ do |number_of_lives|
  @recent_project.update_attributes!(:primary_lives_impacted => number_of_lives.to_i)
end 

Given /^that project has one regular donation$/ do
  @recent_donation = Factory.create(:donation, 
                                    :project => @recent_project, 
                                    :offline => false,
                                    :donation_cp => @recent_project.cp)
end

Given /^that project has a donation without an associated user$/ do
  @recent_donation = Factory.create(:donation,
                                    :project => @recent_project,
                                    :offline => false,
                                    :donation_cp => nil)
end

Given /^that project has a photo album$/ do
  @recent_project.media_albums << Factory.create(:media_album, :user => @recent_project.cp)
end

Then /^I should not see that project\'s name$/ do
  Then "I should not see \"#{@recent_project.name}\""
end


Given /^that project is partners with "([^\"]*)"$/ do |partner_name|
  partner = Partner.find_by_display_name(partner_name)
  @recent_project.update_attributes!(:partner => partner)
end

Given /^that project has status "([^\"]*)"$/ do |project_status_name|
  project_status = ProjectStatus.find_by_display_name(project_status_name)
  if(ProjectStatus.statuses_that_must_have_a_cp.include?(project_status) && @recent_project.cp.nil?)
    @recent_project.cp = Factory.create("cp")
  end
  if(ProjectStatus.statuses_that_must_be_done_fundraising.include?(project_status))
    amount = @recent_project.total_cost_in_us_cents - @recent_project.total_amount_raised_in_cents
    Factory.create(:donation, :amount_in_cents => amount, :project => @recent_project, :offline => true) if amount > 0
  end
    
  @recent_project.project_status = project_status
  @recent_project.save!
end

Given /^that project has the name "([^\"]*)"$/ do |project_name|
  @recent_project.update_attributes!(:name => project_name)
end

Given /^that project has one status update report$/ do
  Factory.create(:partner_project_status_update, :project => @recent_project, :user => @recent_user)
end

Given /^that project has a progress report$/ do
  @recent_progress_report = Factory.create(:partner_project_progress_report, 
                                           :project => @recent_project,
                                           :user => @recent_user
                                           )
end

Given /^that project has a final report$/ do
  @recent_final_report = Factory.create(:partner_project_final_report, 
                                        :project => @recent_project, 
                                        :approval => Factory.create(:approval),
                                        :user => @recent_user)
end

Given /^that progress report has status "([^\"]*)"$/ do |status_name|
  # It's not clear what I should do in this step. The Approval object
  # that is associated with reports doesn't have an explicit
  # awaiting state, just the absence of other data. I'm leaving this
  # blank so at least it's obvious when looking at the code that I do nothing.
  true
end

Given /^that final report has status "([^\"]*)"$/ do |status_name|
  Given %Q{that progress report has status "#{status_name}"}
end

Given /^that project has "([^\"]*)" impact report$/ do |number_of_reports|
  number_of_reports.to_i.times do 
    Factory.create(:partner_project_impact_report, 
                   :project => @recent_project, 
                   :approval => Factory.create(:approval),
                   :user => @recent_user)
  end
end

Given /^that impact report has status Awaiting Approval$/ do
  Given %Q{that progress report has status "Awaiting Approval"}
end

Given /^that project has just recieved its final donation$/ do
  amount = @recent_project.total_cost_in_us_cents - @recent_project.total_amount_raised_in_cents
  Factory.create(:donation, 
                 :amount_in_cents => amount, 
                 :project => @recent_project,
                 :offline => true,
                 :donation_cp => @recent_project.cp)
  @recent_project.reload
  @recent_project.update_attributes!(:project_status => ProjectStatus.planning)
end

And /^fundraising for that project is marked as finished$/ do
  @recent_project.reload
  @recent_project.update_attributes!(:project_status => ProjectStatus.planning)
end

Then /^that project should have an approved at time$/ do
  @recent_project.reload
  @recent_project.approved_by_citizen_effect_at.blank?.should == false
end

Given /^that project does not have an approved at time$/ do
  @recent_project.approved_by_citizen_effect_at = nil
  @recent_project.save!
  @recent_project.approved_by_citizen_effect_at.blank?.should == true
end

Given /^that project has a donation$/ do
  @recent_donation = Factory.create(:donation)
  @recent_project.donations << @recent_donation
end
