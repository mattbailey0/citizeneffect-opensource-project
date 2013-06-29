When /^there is a CP Application for a Project for "([^\"]*)"$/ do |name|
  _name = name.split
  u = Factory.create("basic_user", :first_name => _name[0], :last_name => _name[1])
  p = Factory.create(:project)
  cpa = Factory.create(:cp_application, :project => p, :user => u)
end

Given /^there is an approved CP Application for "([^\"]*)"$/ do |name|
  _name = name.split
  u = Factory.create("basic_user", :first_name => _name[0], :last_name => _name[1])
  p = Factory.create(:project)
  cpa = Factory.create("approved_cp_application", :user => u)
end

Given /^there is a denied CP Application for "([^\"]*)"$/ do |name|
  _name = name.split
  u = Factory.create("basic_user", :first_name => _name[0], :last_name => _name[1])
  p = Factory.create(:project)
  cpa = Factory.create("denied_cp_application", :user => u)
end

Then /I should receive a CP Application submitted email$/ do
  user_email = (@recent_user.andand.email || User.last.email)
  user = EmailUser.find_by_email_address(user_email)
  email = EmailUserAssociation.find_by_email_user_id(user.id, :conditions => 
                                                     {:emailable_type => "CpApplicationSubmittedEmail"}).emailable
  email.subject.should == "[Citizen Effect] We have received your CP Application"
end

Then /^I should receive (a|an) User Signup Notification email$/ do |bogus|
  user_email = (@recent_user.andand.email || User.last.email)
  user = EmailUser.find_by_email_address(user_email)
  email = EmailUserAssociation.find_by_email_user_id(user.id, :conditions => 
                                                     {:emailable_type => "UserSignupNotificationEmail"}).emailable
  email.subject.should == "[Citizen Effect] Activate Your Account"
end

Then /^"([^\"]*)" should receive a CP Application denied email$/ do |name|
  user_email = User.find_by_first_name_and_last_name(name.split[0], name.split[1]).andand.email
  user = EmailUser.find_by_email_address(user_email)
  email = EmailUserAssociation.find_by_email_user_id(user.id, :conditions => 
                                                     {:emailable_type => "CpApplicationDeniedEmail"}).emailable
  email.subject.should == "[Citizen Effect] Your CP Application has been denied."
end

Then /^"([^\"]*)" should receive a CP Application approved email$/ do |name|
  user_email = User.find_by_first_name_and_last_name(name.split[0], name.split[1]).andand.email
  user = EmailUser.find_by_email_address(user_email)
  email = EmailUserAssociation.find_by_email_user_id(user.id, :conditions => 
                                                     {:emailable_type => "CpApplicationApprovedEmail"}).emailable
  email.subject.should == "[Citizen Effect] Your CP Application has been approved!"
end

Then /^"([^\"]*)" should receive a Mailing List email$/ do |email|
  user = EmailUser.find_by_email_address(email)
  @recent_email = EmailUserAssociation.find_by_email_user_id(user.id, :conditions => 
                                                     {:emailable_type => "MailingListSentEmail"}).emailable
  @recent_email.nil?.should == false
end

Then /^"([^\"]*)" should receive a New CP Application email$/ do |email|
  user = EmailUser.find_by_email_address(email)
  @recent_email = EmailUserAssociation.find_by_email_user_id(user.id, :conditions => 
                                                     {:emailable_type => "NewCPApplicationEmail"}).emailable
  @recent_email.nil?.should == false
end

Then /^the CP for that project should receive a donation made email$/ do
  address = @recent_project.cp.email
  user = EmailUser.find_by_email_address(address)
  email = EmailUserAssociation.find_by_email_user_id(user.id, :conditions => 
                                                     {:emailable_type => "CpDonationMadeEmail"}).emailable
  email.subject.should == "[Citizen Effect] A donation has been made to your project!"
end


