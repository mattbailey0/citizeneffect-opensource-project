Given /^"([^\"]*)" is subscribed to the mailing list for that project$/ do |email|
  MailingListUser.create!(:email => email, :mailing_list => @recent_project.mailing_list)
end

Given /^that project sends a mailing list email with subject "([^\"]*)" and contents "([^\"]*)"$/ do |s, c|
  email = MailingListEmail.create!(:mailing_list  => @recent_project.mailing_list,
                                   :subject       => s,
                                   :mail_contents => c,
                                   :sender        => @recent_project.cp)
  email.send_now!
end

Given /^"([^\"]*)" is subscribed to the global mailing list$/ do |email|
  MailingListUser.create!(:email => email, :mailing_list => MailingList.global_list)
end
