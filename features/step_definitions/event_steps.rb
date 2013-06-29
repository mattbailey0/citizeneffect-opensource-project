Then /^I should not see the name of that event$/ do
  Then "I should not see \"#{@recent_event.name}\""
end

Given /^that event is named "([^\"]*)"$/ do |name|
  @recent_event.update_attributes!(:name => name)
end

Then /^I should see the name of that event$/ do
  Then "I should see \"#{@recent_event.name}\""
end

Then /^I check the name of that event$/ do
  When "I check \"#{@recent_event.name}\""
end

When /^I view that event page$/ do
  $browser.goto @host + project_event_path(@recent_event)
  assert_successful_response
end

Then /^"([^\"]*)" should receive a Project Event Invitation email$/ do |email|
  user = EmailUser.find_by_email_address(email)
  @recent_email = EmailUserAssociation.find_by_email_user_id(user.id, :conditions => { :emailable_type => "ProjectEventInvitationSentEmail"}).emailable
  @recent_email.nil?.should == false
end
