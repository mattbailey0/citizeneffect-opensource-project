Feature: Donations
  In order to be charitable
  As an End User
  I want to donate to Citizen Effect and Projects
  
  @shouldwork
  Scenario: Anonymous User Donates Custom Amount to Citizen Effect and Creates An Account
    Given I am logged out
    When I view the homepage
    Then I should see "DONATION"
    When I follow "DONATION"
    Then I should see "DONATE TO CITIZEN EFFECT"
    And I fill in "First name" with "Biz"
    And I fill in "Last name" with "Stone"
    And I fill in "Email" with ""
    And I fill in "ZIP/Postal Code" with "94101"
    And I fill in "Address" with "1 Market Street"
    And I fill in "City" with "San Francisco"
    And I fill in "State/Province/Region" with "CA"
    And I fill in "Phone Number" with "(888) 123-2345"
    And I select "Other" from "DONATION AMOUNT"
    And I fill in "donation_other_amount_in_dollars" with "72.50"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Biz"
    And I should see "You've donated $72.50"
    And I should see "If you don't have an account"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    And I press an image button with class "create_account"
    Then I should see "Thanks for signing up! We're sending you an email with your activation code."
    And delayed job runs
    And I should receive a User Signup Notification email
    And I should receive a Donation Receipt email
    And that email should contain "In the coming year, we will be helping hundreds of Citizen Philanthropists"
    When I go to the activation page
    Then I should see "Signup complete!"
    When I go to my profile page
    And I should see "Total Donated: $73"
    And I should see "E-MAIL LISTS BIZ BELONGS TO (1)"
    And I should see "Citizen Effect Mailing List"

  @shouldwork 
  Scenario: New User Donates through Yoga Challenge
    Given I am logged out
    When I go to the yoga challenge donation page
    Then I should see "JOIN THE YOGA CHALLENGE"
    And I fill in "First name" with "Biz"
    And I fill in "Last name" with "Stone"
    And I fill in "Email" with ""
    And I fill in "ZIP/Postal Code" with "94101"
    And I fill in "Address" with "1 Market Street"
    And I fill in "City" with "San Francisco"
    And I fill in "State/Province/Region" with "CA"
    And I fill in "Phone Number" with "(888) 123-2345"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I check id "donation_fundraise_commitment"
    And I fill in "Password" with "secret"
    And I fill in "Password Confirmation" with "secret"
    And I fill in "donation_referred_by" with "Hi"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you for joining Citizen Effect's Yoga Challenge!"
    And I should see "YOGA CHALLENGE SIGN UP CONFIRMATION"
    And delayed job runs
    And I should receive a Donation Receipt email
    And that email should contain "Your support will help DC-based Becky's Fund address domestic abuse in our community"
    And I should receive a User Signup Notification email
    And "" should receive a New CP Application email
    And that email should contain "Yoga Challenge 2011: Hi"
    When I go to the activation page
    Then I should see "Signup complete!"
    When I go to my profile page
    And I should see "Total Donated: $25"
    And I should see "E-MAIL LISTS BIZ BELONGS TO (1)"
    And I should see "Citizen Effect Mailing List"

  @shouldwork
  Scenario: Existing User Donates through Yoga Challenge
    Given I am logged out
    And there is a user named "Jane Doe"
    And that user has the email "janedoetest@donation.com"
    And that user has the address "401 Mission Street"
    And that user has donated "100" dollars
    When I go to the yoga challenge donation page
    And I should see "Already have an account?"
    When I follow "Log in"
    And I fill in "login_page" with "someone@example.com"
    And I fill in "password_page" with "password"
    And I press an image button with class "login_button"
    When I go to the yoga challenge donation page
    Then I should see "JOIN THE YOGA CHALLENGE"
    And I fill in "Phone Number" with "(888) 123-2345"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I check id "donation_fundraise_commitment"
    And I fill in "donation_referred_by" with "Hi"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you for joining Citizen Effect's Yoga Challenge!"
    And I should see "YOGA CHALLENGE SIGN UP CONFIRMATION"
    And delayed job runs
    And I should receive a Donation Receipt email
    And that email should contain "Your support will help DC-based Becky's Fund address domestic abuse in our community"
    And "" should receive a New CP Application email
    And that email should contain "Yoga Challenge 2011: Hi"
    When I go to my profile page
    And I should see "Total Donated: $125"
    And I should see "E-MAIL LISTS JANE BELONGS TO (1)"
    And I should see "Citizen Effect Mailing List"

  Scenario: Anonymous User Donates Custom Amount to Citizen Effect through BwB Donation Page with DI
    Given I am logged out
    When I go to the bwb donation page
    Then I should see "JOIN BRACKETS WITH BENEFITS"
    And I fill in "First name" with "Biz"
    And I fill in "Last name" with "Stone"
    And I fill in "Email" with ""
    And I fill in "ZIP/Postal Code" with "94101"
    And I fill in "Address" with "1 Market Street"
    And I fill in "City" with "San Francisco"
    And I fill in "State/Province/Region" with "CA"
    And I fill in "Phone Number" with "(888) 123-2345"
    And I select "Other" from "DONATION AMOUNT"
    And I fill in "donation_other_amount_in_dollars" with "72.50"
    And I check "DOUBLE YOUR IMPACT"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    And I should see "BRACKETS WITH BENEFITS DONATION CONFIRMATION"
    And delayed job runs
    And he should receive a Donation Receipt email
    And that email should contain "Thanks for your generous donation of $82.50 to join Citizen Effect's Brackets with Benefits!"

  Scenario: Anonymous User Donates Custom Amount to Citizen Effect through BwB Donation Page
    Given I am logged out
    When I go to the bwb donation page
    Then I should see "JOIN BRACKETS WITH BENEFITS"
    And I fill in "First name" with "Biz"
    And I fill in "Last name" with "Stone"
    And I fill in "Email" with ""
    And I fill in "ZIP/Postal Code" with "94101"
    And I fill in "Address" with "1 Market Street"
    And I fill in "City" with "San Francisco"
    And I fill in "State/Province/Region" with "CA"
    And I fill in "Phone Number" with "(888) 123-2345"
    And I select "Other" from "DONATION AMOUNT"
    And I fill in "donation_other_amount_in_dollars" with "72.50"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    And I should see "BRACKETS WITH BENEFITS DONATION CONFIRMATION"
    And delayed job runs
    And he should receive a Donation Receipt email
    And that email should contain "Thanks for your generous donation of $72.50 to join Citizen Effect's Brackets with Benefits!"

  @shouldwork
  Scenario: User Goes to Donate Page, Logs in, and Donates to Citizen Effect
    Given I am logged out
    And there is a user named "Jane Doe"
    And that user has the email "someone@exmaple.com"
    And that user has the address "x"
    And that user has donated "100" dollars
    When I view the homepage
    Then I should see "DONATION"
    When I follow "DONATION"
    Then I should see "DONATE TO CITIZEN EFFECT"
    And I should see "Already have an account?"
    When I follow "Log in"
    And I fill in "login_page" with "someone@exmaple.com"
    And I fill in "password_page" with "password"
    And I press an image button with class "login_button"
    Then I should see "Logout"
    Then I should see "DONATE TO CITIZEN EFFECT"
    And I should see "401 Mission Street"
    And I select "$50.00" from "DONATION AMOUNT"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Jane"
    And I should see "You've donated $50"
    When I follow "Profile"
    Then I should see "Total Donated: $150"

  @shouldwork
  Scenario: Logged In User Donates to Citizen Effect and signs up for mailing list
    Given there is a user named "Jane Doe"
    And that user has the address "x"
    And that user has donated "100" dollars
    And I am logged in as "Jane Doe"
    When I view the homepage
    Then I should see "DONATION"
    When I follow "DONATION"
    Then I should see "DONATE TO CITIZEN EFFECT"
    And I should see "401 Mission Street"
    And I select "$100.00" from "DONATION AMOUNT"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Jane"
    And I should see "You've donated $100"
    When I follow "Profile"
    Then I should see "Total Donated: $200"
    And I should see "E-MAIL LISTS JANE BELONGS TO (1)"
    And I should see "Citizen Effect Mailing List"

  @shouldwork
  Scenario: Anonymous User Donates to Project, Joins Mailing List, and Creates An Account
    Given I am logged out
    And there is a project named "Donation Test 1"
    And that project is user visible
    And that project has a CP
    And that project has a total cost of "200" dollars
    When I view that project
    Then I should see an image link with class "donate_to_project"
    When I follow an image link with class "donate_to_project"
    Then I should see "DONATE TO"
    And I should see the name of that project in all caps
    And I fill in "First name" with "Biz"
    And I fill in "Last name" with "Stone"
    And I fill in "Email" with ""
    And I fill in "ZIP/Postal Code" with "94101"
    And I fill in "Address" with "1 Market Street"
    And I fill in "City" with "San Francisco"
    And I fill in "State/Province/Region" with "CA"
    And I fill in "Phone Number" with "(888) 123-2345"
    And I select "$50.00" from "DONATION AMOUNT"
    And I select "10%" from "TIP"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Biz"
    And I should see "You've donated $55"
    And I should see "If you don't have an account"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    And I press an image button with class "create_account"
    And delayed job runs
    And I should receive a User Signup Notification email
    And I should receive a Donation Receipt email
    And that email should contain "Bookmark the project page below to stay up-to-date with the project "
    Then I should see "Thanks for signing up! We're sending you an email with your activation code."
    When I go to the activation page
    Then I should see "Signup complete!"
    When I go to my profile page
    And I should see "Total Donated: $55"
    And I should see "E-MAIL LISTS BIZ BELONGS TO (2)"
    And I should see "Citizen Effect Mailing List"
    And I should see "Donation Test 1 Mailing List"
    And I should see "PROJECTS BIZ HAS DONATED TO (1)"
    And I should see "$49 of $200 raised from 1 donors"
    And the CP for that project should receive a donation made email

  @shouldwork
  Scenario: Logged In User Donates to Project
    Given there is a user named "Jane Doe"
    And that user has the address "x"
    And that user has donated "100" dollars
    And I am logged in as "Jane Doe"
    And there is a project named "Donation Test 2"
    And that project is user visible
    And that project has a CP
    And that project has a total cost of "200" dollars
    When I view that project
    Then I should see an image link with class "donate_to_project"
    When I follow an image link with class "donate_to_project"
    Then I should see "DONATE TO"
    And I should see the name of that project in all caps
    And I should see "401 Mission Street"
    And I select "$100.00" from "DONATION AMOUNT"
    And I select "20%" from "TIP"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Jane"
    And I should see "You've donated $120"
    When I follow "Profile"
    Then I should see "Total Donated: $220"
    And I should see "E-MAIL LISTS JANE BELONGS TO (2)"
    And I should see "Citizen Effect Mailing List"
    And I should see "Donation Test 2 Mailing List"
    And I should see "PROJECTS JANE HAS DONATED TO (1)"
    And I should see "$97 of $200 raised from 1 donors"
    And the CP for that project should receive a donation made email

  @shouldwork
  Scenario: Logged In User Donates to "no credit card fee" project
    Given there is a user named "Jane Doe"
    And that user has the address "401 Mission Street"
    And that user has donated "100" dollars
    And I am logged in as "Jane Doe"
    And there is a project named "No Credit Card Fee Project"
    And that project has "no_credit_card_fee" set to "true"
    And that project is user visible
    And that project has a CP
    And that project has a total cost of "200" dollars
    When I view that project
    Then I should see an image link with class "donate_to_project"
    When I follow an image link with class "donate_to_project"
    Then I should see "DONATE TO"
    And I should see the name of that project in all caps
    And I should see "401 Mission Street"
    And I select "$100.00" from "DONATION AMOUNT"
    And I select "20%" from "TIP"
    And I should not see "credit card fees"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Jane"
    And I should see "You've donated $120"
    When I follow "Profile"
    Then I should see "Total Donated: $220"
    And I should see "E-MAIL LISTS JANE BELONGS TO (2)"
    And I should see "Citizen Effect Mailing List"
    And I should see "No Credit Card Fee Project Mailing List"
    And I should see "PROJECTS JANE HAS DONATED TO (1)"
    And I should see "$100 of $200 raised from 1 donors"
    And the CP for that project should receive a donation made email

  @shouldwork
  Scenario: Logged In User Donates to "no tip request" project
    Given there is a user named "Jane Doe"
    And that user has the address "401 Mission Street"
    And that user has donated "100" dollars
    And I am logged in as "Jane Doe"
    And there is a project named "No Request Project"
    And that project has "no_tip_request" set to "true"
    And that project is user visible
    And that project has a CP
    And that project has a total cost of "200" dollars
    When I view that project
    Then I should see an image link with class "donate_to_project"
    When I follow an image link with class "donate_to_project"
    Then I should see "DONATE TO"
    And I should see the name of that project in all caps
    And I should see "401 Mission Street"
    And I select "$100.00" from "DONATION AMOUNT"
    And I should not see "TIP"
    And I should see "credit card fees"
    And I check "I agree to the Terms of Service"
    And I fill in the credit card information
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Jane"
    And I should see "You've donated $100"
    When I follow "Profile"
    Then I should see "Total Donated: $200"
    And I should see "E-MAIL LISTS JANE BELONGS TO (2)"
    And I should see "Citizen Effect Mailing List"
    And I should see "No Request Project Mailing List"
    And I should see "PROJECTS JANE HAS DONATED TO (1)"
    And I should see "$97 of $200 raised from 1 donors"
    And the CP for that project should receive a donation made email

  @shouldwork
  Scenario: Donate button hides after press to avoid double press
    Given I am logged out
    When I view the homepage
    Then I should see "DONATION"
    When I follow "DONATION"
    Then I should see "DONATE TO CITIZEN EFFECT"
    When I press an image button with class "confirm_donate"
    Then I should not see an image button with class "confirm_donate"
    When I wait for the AJAX call to finish
    Then I should see an image button with class "confirm_donate"

  @shouldwork
  Scenario: View all donors on project page
    Given there is a project named "Donation Test 2"
    And that project is user visible
    And that project has a CP
    And that project has a total cost of "200" dollars
    And that project has a donation
    And that donation has "first_name" set to "donation1"
    And I sleep "1.5"
    And that project has a donation
    And that donation has "first_name" set to "donation2"
    And I sleep "1.5"
    And that project has a donation
    And that donation has "first_name" set to "donation3"
    And I sleep "1.5"
    And that project has a donation
    And that donation has "first_name" set to "donation4"
    And I sleep "1.5"
    And that project has a donation
    And that donation has "first_name" set to "donation5"
    And I sleep "1.5"
    And that project has a donation
    And that donation has "first_name" set to "donation6"
    And I sleep "1.5"
    And that project has a donation
    And that donation has "first_name" set to "donation7"
    When I view that project
    Then I should see "donation7"
    And I should see "donation6"
    And I should see "donation5"
    And I should see "donation4"
    And I should see "donation3"
    And I should not see "donation2"
    When I click a link with id "project_donors_view_more"
    And I wait for the AJAX call to finish
    Then I should see "donation2"
    And I should see "donation1"

  @shouldwork
  Scenario: Logged In User Donates Anonymously to Project
    Given there is a user named "Jane Doe"
    And that user has the address "x"
    And that user has donated "100" dollars
    And I am logged in as "Jane Doe"
    And there is a project named "Donation Test 3"
    And that project is user visible
    And that project has a CP
    And that project has a total cost of "200" dollars
    When I view that project
    Then I should see an image link with class "donate_to_project"
    When I follow an image link with class "donate_to_project"
    Then I should see "DONATE TO"
    And I should see the name of that project in all caps
    And I should see "401 Mission Street"
    And I select "$100.00" from "DONATION AMOUNT"
    And I select "0%" from "TIP"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I check "I prefer to remain anonymous"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Jane"
    And I should see "You've donated $100"
    When I follow "Profile"
    Then I should see "Total Donated: $100"
    And I should see "E-MAIL LISTS JANE BELONGS TO (2)"
    And I should see "Citizen Effect Mailing List"
    And I should see "Donation Test 3 Mailing List"
    And I should see "PROJECTS JANE HAS DONATED TO (0)"
    And I should see "ANONYMOUS DONATIONS (1)"
    And I should see "$97 of $200 raised from 1 donors"
    And the CP for that project should receive a donation made email

  @shouldwork
  Scenario: Project's Final Donation
    Given there is a project
    And there is a user named "Admin Guy"
    And that user has the email "admin@example.org"
    And I have the role "citizen_effect_admin"
    And there is a user named "John Smith"
    And that project has a CP named "John Smith"
    And that project has a total cost of "1100" dollars
    And that project has a total donation amount of "1003" dollars
    And there is a user named "Jane Doe"
    And that user has the email "someone@example.com
    And that user has the address "x"
    And that user has donated "100" dollars
    And I am logged out
    When I view that project
    Then I should see an image link with class "donate_to_project"
    When I follow an image link with class "donate_to_project"
    Then I should see "DONATE TO"
    And I should see the name of that project in all caps
    And I should see "Already have an account?"
    When I follow "Log in"
    And I fill in "login_page" with "someone@example.com"
    And I fill in "password_page" with "password"
    And I press an image button with class "login_button"
    Then I should see "Logout"
    Then I should see "DONATE TO"
    And I should see the name of that project in all caps
    And I should see "401 Mission Street"
    And I select "$100.00" from "DONATION AMOUNT"
    And I select "0%" from "TIP"
    And I fill in the credit card information
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Jane"
    And I should see an image link with class "return-button"
    And fundraising for that project is marked as finished
    When I follow an image link with class "return-button"
    Then I should not see an image link with class "donate_to_project"
    And I should see "$1,100 of $1,100 raised from 2 donors"
    And the CP for that project should receive a donation made email    
