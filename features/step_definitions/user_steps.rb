Given /^there is a user named "([^\"]*)"$/ do |name|
  @users ||= {}
  first_name, last_name = name.split(" ")
  @users[name] = Factory.create(:user, :first_name => first_name, :last_name => last_name)
  @recent_user = @users[name]
end

When /^I go to the activation page$/ do
  @recent_user ||= User.last
  activation_path = activate_path(:activation_code => @recent_user.activation_code)
  $browser.goto "#{@host}#{activation_path}"
#  visit activate_path(:activation_code => @recent_user.activation_code)
end

When /^I log in as "([^\"]*)"$/ do |name|
  Given "I am logged in as \"#{name}\""
end

Given /^I have the role "([^\"]*)"$/ do |role_name|
  r = Role.find_by_name(role_name)
  @recent_user.roles.add!(r)
end

Given /^that user has the role "([^\"]*)"$/ do |role_name|
  Given %Q{I have the role "#{role_name}"}
end

Given /^that user has the email "([^\"]*)"$/ do |email_address|
  @recent_user.update_attributes!(:email => email_address)
end

Given /^that user has impacted "([^\"]*)" lives as a donor$/ do |number_of_lives|
  number_of_lives = number_of_lives.to_i
  number_of_lives_to_add =  number_of_lives - @recent_user.lives_impacted_as_donor

  p = Factory.create(:project, :primary_lives_impacted => number_of_lives_to_add, :secondary_lives_impacted => 0)
  p.cp = Factory.create("cp")
  p.project_status = ProjectStatus.fundraising
  p.save!
  
  Factory.create(:donation, :donor => @recent_user, :project => p)
end

Given /^that user has impacted "([^\"]*)" lives as a CP$/ do |number_of_lives|
  number_of_lives = number_of_lives.to_i
  number_of_lives_to_add = number_of_lives - @recent_user.lives_impacted_as_cp
  
  @recent_user.roles << Role.cp
  @recent_user.save!

  p = Factory.create(:project, :primary_lives_impacted => number_of_lives_to_add, :secondary_lives_impacted => 0)
  p.cp = @recent_user
  p.project_status = ProjectStatus.fundraising
  p.save!
  amount = p.total_cost_in_us_cents - p.total_amount_raised_in_cents
  Factory.create(:donation, 
                 :amount_in_cents => amount,
                 :offline => true,
                 :project => p,
                 :donation_cp => p.cp)
end

Given /^that user has the address "([^\"]*)"$/ do |address|
  @recent_user.update_attributes!(:address1 => address)
end

Given /^that user has the zip code "([^\"]*)"$/ do |zip|
  @recent_user.update_attributes!(:zip => zip)
end

Given /^that user has donated "([^\"]*)" dollars$/ do |amount|
  amount = (amount.to_f * 100).to_i
  amount = amount - @recent_user.donation_total_in_cents

  Factory.create(:donation, :donor => @recent_user, :amount_in_cents => amount)
end

Given /^that user has raised "([^\"]*)" dollars$/ do |amount|
  amount = (amount.to_f * 100).to_i
  amount = amount - @recent_user.money_raised_in_cents
  
  p = Factory.create(:project)
  p.cp = @recent_user
  p.project_status = ProjectStatus.fundraising
  p.save!
  
  Factory.create(:donation, :donation_cp => @recent_user, :amount_in_cents => amount, 
                 :offline => true, :project => p)
end

Given /^that user has donated to "([^\"]*)" projects$/ do |count|
  count.to_i.times do
    p = Factory.create(:project)
    p.cp = Factory.create("cp")
    p.save
  
    Factory.create(:donation, :donor => @recent_user, :project => p)
  end
end

Given /^that user has completed "([^\"]*)" projects$/ do |count|
  count.to_i.times do
    p = Factory.create(:project)
    p.cp = @recent_user
    p.project_status = ProjectStatus.fundraising
    p.save!
    amount = p.total_cost_in_us_cents - p.total_amount_raised_in_cents
    Factory.create(:donation, 
                   :amount_in_cents => amount, 
                   :offline => true,
                   :project => p,
                   :donation_cp => p.cp)
    p.reload
    p.update_attributes!(:project_status => ProjectStatus.planning)
  end
end

When /I go to my profile page/ do
  $browser.goto "#{@host}#{user_path(@recent_user)}"
end

Given /^that user has an imported contact$/ do
  @recent_contact = Factory.create(:imported_contact, :referrer => @recent_user)
end

Given /^that imported contact has the email "([^\"]*)"$/ do |email|
  @recent_contact.update_attributes!(:email => email)
end

Given /^that imported contact has the name "([^\"]*)"$/ do |name|
  @recent_contact.update_attributes!(:name => name)
end

Given /^I am subscribed to the mailing list for that project$/ do
  @recent_user.mailing_lists << @recent_project.mailing_list
  @recent_user.save!
end

Given /^that user has at least one message$/ do
  @recent_message = Message.create!(:recipient => @recent_user)
end

Given /^that message is from "([^\"]*)"$/ do |name|
  first_name, last_name = name.split(" ")
  @recent_message.sender = Factory.create(:user, :first_name => first_name, :last_name => last_name)
  @recent_message.save!
end

Given /^that message has the subject "([^\"]*)"$/ do |subject|
  @recent_message.subject = subject
  @recent_message.save!
end

Given /^that message has the contents "([^\"]*)"$/ do |body|
  @recent_message.body = body
  @recent_message.save!
end

Given /^I am logged in as an admin for partner "([^\"]*)"$/ do |partner_name|
  Given %Q{there is a user named "Hobo McElbow"}
  Given %Q{I am logged in as "Hobo McElbow"}
  partner = Partner.find_by_display_name(partner_name)
  @recent_user.partner_admin_associations.build(:partner => partner)
  @recent_user.save!
end

Then /^"([^\"]*)" should receive a Imported Contact Email$/ do |user_email|
#  user_email = (@recent_user.andand.email || User.last.email)
  
  user = EmailUser.find_by_email_address(user_email)
  @recent_email = email = EmailUserAssociation.find_by_email_user_id(user.id, :conditions => 
                                                     {:emailable_type => "ImportedContactEmail"}).emailable
  
  #email.subject.should == "[Citizen Effect] Account confirmation"

end

Then /^that email should have "([^\"]*)" in the subject$/ do |subject|
  @recent_email.subject.should == subject
end

Given /^that user has no picture$/ do 
  @recent_user.picture.destroy
  @recent_user.save!
  @recent_user.picture(true).should == nil
end

Given /^that user is not active$/ do
  @recent_user.state = "pending"
  @recent_user.activated_at = nil
  @recent_user.activation_code = nil
  @recent_user.save!
end

When /^I (click|follow) "(.*)" for "(.*)"$/ do |x, link, email|
  begin
    $browser.row(:text => /#{Regexp.escape(email)}/).link(:text => /#{Regexp.escape(link)}/).click
  rescue Exception => e
    open_current_html_in_browser_
    raise
  end
  assert_successful_response
end
