@users = {}
# Given I am logged in as a "basic_user" #"Jane Doe"
Given /^I am logged out$/ do
  $browser.goto @host + "/logout"
end

Given /^I am not logged in$/ do
  Given "I am logged out"
end

Given /^there is a "([^\"]*)" user with email "([^\"]*)" and password "([^\"]*)"$/ do |role_name, email, password|
  role = Role.find_by_name(role_name)
  Factory.create(:user, :roles => [role], :email => email, :password => password, :password_confirmation => password)
end

Given /^there is a user with the email "([^\"]*)" and name "([^\"]*)"$/ do |email, name|
  Factory.create(:user, :email => email, :first_name => name.split(" ").first, :last_name => name.split(" ")[1, 10].join(" "))
end

Given /^I am logged in as a "([^\"]*)"$/ do |role_name|
  u = Factory.create(role_name)
  login_user_with_default_password(u)
end

And /^I sleep for "([^\"]*)" seconds$/ do |num|
  sleep num.to_f
end

def login_user_with_default_password(user)
  password = user.password
  password ||= "password"
  @recent_user = user
  Then "I go to the homepage"
  And "I fill in \"login\" with \"#{user.email}\""
  And "I fill in \"password\" with \"#{password}\""
  And "I press the login button"
  And "I should see \"Logged in successfully\""
end

Given /^there is a Partner with the name "([^\"]*)"$/ do |name|
  Factory.create(:partner, :display_name => name)
end

Given /^there is a CP with the name "([^\"]*)"$/ do |name|
  _name = name.split
  role = Role.find_by_name("cp")
  u = Factory.create(:user, :first_name => _name[0], :last_name => _name[1], :roles => [role])
  @recent_user = u
end

Given /^there is a basic user with the name "([^\"]*)"$/ do |name|
  _name = name.split
  role = Role.find_by_name("basic_user")
  u = Factory.create(:user, :first_name => _name[0], :last_name => _name[1], :roles => [role])
  @recent_user = u
end

Given /^a project with a cp$/ do
  Factory.create(:project, :cp => Factory.create(:user, :roles => [Role.find_by_name("cp")]), :name => name, :approved_by_citizen_effect_at => 1.day.ago)
end

When /^I confirm$/ do
  # STUB - this is a placeholder.  The official ways to handle confirm dialogs are all failing
end

When /^I visit the administration index page$/ do
  visit "/"
end

When /^"([^\"]*)" is currently highlighted$/ do |text|
  div = $browser.div(:text  => "#{text}", 
                     :class => /highlight/) #:class => /#{Regexp.escape(text.gsub(/ /,"_").tableize)}/)
  begin
    div.html
  rescue
    raise("div containing \"#{text}\" is not highlighted")
  end
end

When /^I click the regular page url ending in "([^\"]*)"$/ do |permalink_text|
  When "I click \"#{RegularPage::URL_BASE}#{permalink_text}\""
end

Given /^there are some projects$/ do
  5.times { Factory.create(:project) }
end

Given /^I haven\'t been to the site before$/ do
  $browser.clear_cookies
end

# Then /^I should not see text "([^\"]*)" with class "([^\"]*)"$/ do |text, klass|
#   div = $browser.div(:text => /#{text}/, :class => klass).html rescue nil
#   begin
#     div.should be_nil
#   rescue
#     open_current_html_in_browser_
#     raise("found div with '#{text}'")
#   end
# end

# Then /^I should see text "([^\"]*)" with class "([^\"]*)"$/ do |text, klass|
#   div = $browser.div(:text => /#{text}/, :class => /#{klass}/)
#   begin
#     div.html
#   rescue
#     open_current_html_in_browser_
#     raise("div with '#{text}' not found")
#   end
# end

When /I press the login button/ do
  $browser.form(:id, "login_form").button(:type, "image").click
  assert_successful_response
end

When /I press the send button/ do
  When "I press \"Send\""
end

When /I press the save button/ do
  When "I press \"Save\""
end

When /I press the submit button/ do
  When "I press \"Submit\""
end

Given /^there is a fundraiser type named "([^\"]*)"$/ do |name|
  Factory.create(:fundraiser_type, :name => name)
end

Given /^there is a fundraiser type experience from "([^\"]*)" for "([^\"]*)" with quote "([^\"]*)"$/ do |cp_name, fundraiser_type_name, quote_text|
  ft = FundraiserType.find_by_name(fundraiser_type_name)
  cp = User.find_by_first_name_and_last_name(cp_name.split[0],cp_name.split[1])
  fte = ft.fundraiser_type_experiences.build(:user => cp, :quote => quote_text)
  fte.save
end

When /^I upload an image to a file field with class "([^\"]*)"$/ do |klass|
  default_image = File.join $upload_path, "farmer.jpg"
  $browser.file_field(:class => Regexp.escape(klass)).set(default_image)
end

When /^I upload an image to "([^\"]*)"$/ do |label_text|
  default_image = File.join $upload_path, "farmer.jpg"
  $browser.file_field(:id, find_label(label_text).for).set(default_image)
end

Given /^there is a pdf "([^\"]*)" for "([^\"]*)"$/ do |pdf_file_name, fundraiser_type_name|
  pdf_file = File.join $upload_path, pdf_file_name
  ft = FundraiserType.find_by_name(fundraiser_type_name)
  pdf = ft.associated_files.build(:content => File.open(pdf_file))
  pdf.save
end

When /^I upload a pdf to "([^\"]*)"$/ do |label_text|
  When %Q{I upload a pdf "pdf-test.pdf" to "#{label_text}"}
end

When /^I upload a pdf "([^\"]*)" to "([^\"]*)"$/ do |pdf_name, label_text|
  pdf_file = File.join $upload_path, pdf_name
  $browser.file_field(:id, find_label(label_text).for).set(pdf_file)
end

Given /^the "([^\"]*)" has a contact "([^\"]*)"$/ do |role_name, contact_email|
  u = Role.find_by_name(role_name).users.first
  u.imported_contacts << Factory.create(:imported_contact, :email => contact_email)
end

Given /^the "([^\"]*)" is named "([^\"]*)"$/ do |role_name, user_first_last_name|
  names = user_first_last_name.split
  u = Role.find_by_name(role_name).users.first
  u.first_name = names[0]
  u.last_name = names[1]
  u.save
end

Given /^I am logged in as a partner admin for "([^\"]*)"$/ do |partner_name|
  p = Factory.create(:partner, :display_name => partner_name)
  u = Factory.create("partner_admin")
  p.admins << u
  login_user_with_default_password(u)
end

Given /^I set variable "([^\"]*)"$/ do |arg1|
  @vartest = arg1
end

Given /^I still have the variable "([^\"]*)"$/ do |arg1|
  raise "shit" unless @vartest == arg1
end

Given /^I am logged in as "([^\"]*)"$/ do |name|
  @users ||= {}
  
  first_name, last_name = name.split(" ")
  user = User.find(:first, :conditions => {:first_name => first_name, :last_name => last_name})
  user ||= Factory.create(:user, :first_name => first_name, :last_name => last_name)
  @users[name] = user

  login_user_with_default_password(@users[name])
end

Given /^"([^\"]*)" has the role "([^\"]*)"$/ do |name, role_name|
  u = @users[name]
  role = Role.find_by_name(role_name)
  u.roles.add!(role)
end

When /^I view the homepage$/ do
  When "I go to the homepage"
end

When /^I visit the homepage$/ do
  When "I go to the homepage"
end

Given /^there is a country named$/ do |country_name|
  country = Country.find_by_name(country_name)
  @recent_country = (country || Factory.create(:country, :name => country_name))
end

When /^achievement calculations run$/ do
  Achievement.update_all_achievement_associations
end

Then /^a hidden field named "([^\"]*)" has value "([^\"]*)"$/ do |hidden_field_name, hidden_field_value|
  field = $browser.hidden(:name => hidden_field_name)
  assert_equal hidden_field_value, field.value
end

Then /^"([^\"]*)" should be checked$/ do |field|
  assert $browser.check_box(:id, find_label(field).for).set?
end

When /^I click a campaign email link with tracking code "([^\"]*)"$/ do |code|
  $browser.goto @host + new_mailing_list_mailing_list_user_path(MailingList.global_list, :ctc => code)
  assert_successful_response
end

Then /^the feed should conatin the guid for that blog post$/ do
  assert_match "#{@recent_blog_post.id} at #{ONEWELL_HOST}", $browser.html
end
