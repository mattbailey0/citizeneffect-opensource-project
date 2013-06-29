Then /^that email should have the subject "([^\"]*)"$/ do |subject|
  @recent_email.subject.should == subject
end

Then /^that email should contain "([^\"]*)"$/ do |text|
  assert @recent_email.rendered_email_contents =~ /#{Regexp.escape(text)}/
end

When /^I click the link in the email with "([^\"]*)" as the title$/ do |title|
  links = @recent_email.rendered_email_contents.scan(/<a href="([^\"]*)">#{title}<\/a>/)
  $browser.goto links[0][0]
end

Then /^he should receive (a|an) Donation Receipt email$/ do |bogus|
  @recent_email = DonationReceiptEmail.last
  @recent_email.subject.should == "[Citizen Effect] Thank You For Your Donation!"
end

Then /^I should receive (a|an) Donation Receipt email$/ do |bogus|
  user_email = (@recent_user.andand.email || User.last.email)
  user = EmailUser.find_by_email_address(user_email)
  @recent_email = EmailUserAssociation.find_by_email_user_id(user.id, :conditions => 
                                                     {:emailable_type => "DonationReceiptEmail"}).emailable
  @recent_email.subject.should == "[Citizen Effect] Thank You For Your Donation!"
end
