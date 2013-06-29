Feature: Project's Mailing List
  In order to regularly provide and receive updates to those who care about the project 
  As a Citizen Philanthropist
  I want to join, unsubscribe, and email project mailing list

  @shouldwork
  Scenario: Anonymous user subscribes to project mailing list
    Given I am not logged in
    And there is a project named "Wild And Crazy Well Project in Village"
    And that project is user visible
    And that project has a CP
    When I view that project
    Then I should see "Join our email list, news and updates."
    And I fill in "project_mailing_list_user_email" with "someone@example.com"
    And I press an image button with class "project_mailing_list_join"
    Then I should see "Subscribed to email list successfully."
    And I should see "Wild And Crazy Well Project in Village"
    #And I should see "Create an account to manage your subscriptions"

  @shouldwork  
  Scenario: Anonymous user unsubscribes from project mailing list from sent email on its project page
    Given I am not logged in
    And there is a project named "Wild And Crazy Well Project in Village"
    And that project is user visible
    And that project has a CP
    And "foo@bar.com" is subscribed to the mailing list for that project
    And that project sends a mailing list email with subject "foo" and contents "bar"
    Then "foo@bar.com" should receive a Mailing List email
    Then that email should have the subject "foo"
    When I click the link in the email with "unsubscribe" as the title
    Then I should see "You have successfully unsubscribed from this mailing list."
    And I should see "Wild And Crazy Well Project in Village"

  @shouldwork
  Scenario: Logged in user subscribes to project mailing list and then unsubscribes
    Given there is a user named "Jane Doe"
    And that user has the email "someone@example.com"
    And I am logged in as "Jane Doe"
    And there is a project named "Wild And Crazy Well Project in Village"
    And that project is user visible
    And that project has a CP
    When I view that project
    Then I should see "Join our email list, news and updates."
    Then I should see "someone@example.com"
    And I press an image button with class "project_mailing_list_join"
    Then I should see "Subscribed to email list successfully."
    And I should see "See your subscriptions"
    And I should see "Unsubscribe"
    And I should see "Wild And Crazy Well Project in Village"
    When I follow "See your subscriptions"
    Then I should see "Jane Doe"
    And I should see "E-MAIL LISTS JANE BELONGS TO (2)"
    And I should see "Wild And Crazy Well Project in Village Mailing List"
    And I should see "visit project"
    When I follow "visit project"
    Then I should see "Unsubscribe"
    And I should see "Wild And Crazy Well Project in Village"
    When I follow "Unsubscribe"
    Then I should see "You have successfully unsubscribed from this mailing list."
    And I should see "Wild And Crazy Well Project in Village"
    And I should see "Join our email list, news and updates."
    And I should see "someone@example.com"
    When I follow "Profile"
    And I should see "E-MAIL LISTS JANE BELONGS TO (1)"
    And I should not see "Wild And Crazy Well Project in Village Mailing List"

  @shouldwork
  Scenario: Logged in user unsubscribes from mailing lists on user profile page
    Given there is a user named "Jane Doe" 
    And that user has the email "someone@example.com"
    And I am logged in as "Jane Doe"
    And there is a project named "Wild And Crazy Well Project in Village"
    And "someone@example.com" is subscribed to the mailing list for that project
    When I view the homepage
    Then I should see "Profile"
    When I follow "Profile"
    And I should see "E-MAIL LISTS JANE BELONGS TO (2)"
    And I should see "Wild And Crazy Well Project in Village Mailing List"
    And I should see "Citizen Effect Mailing List"
    Then I should see an image link with class "close_top_left"
    When I follow an image link with class "close_top_left"
    Then I should see "You have successfully unsubscribed from this mailing list."
    And I should see "E-MAIL LISTS JANE BELONGS TO (1)"
    And I should not see "Citizen Effect Mailing List"
    Then I should see an image link with class "close_top_left"
    When I follow an image link with class "close_top_left"
    Then I should see "You have successfully unsubscribed from this mailing list."
    And I should see "E-MAIL LISTS JANE BELONGS TO (0)"
    And I should not see "Wild And Crazy Well Project in Village Mailing List"

  @shouldwork
  Scenario: CP Saves Mailing List Draft
    Given there is a project
    And that project has a CP named "John Smith"
    And I am logged in as "John Smith"
    When I view that project
    And "someone@example.com" is subscribed to the mailing list for that project
    Then I should see "Send Message to Email List"
    When I follow "Send Message to Email List"
    And I fill in "BCC" with "someone@example.com"
    And I fill in "SUBJECT" with "Draft Update on the project!"
    And I fill in "MESSAGE" with "Here is a draft an update on the project."
    And I press an image button with name "save_draft"
    Then I should see "Email draft was successfully saved."
    Then I follow "back to project page"
    Then I follow "Send Message to Email List"
    And I should see "Draft Update on the project!"
    When I follow "Draft Update on the project!"
    And I should see "Here is a draft an update on the project."
    And I should see "someone@example.com"
    And I fill in "BCC" with "someone@example.com"
    And I fill in "SUBJECT" with "Draft Update on the project, again!"
    And I fill in "MESSAGE" with "Some very different text."
    And I press an image button with name "save_draft"
    Then I should see "Email draft was successfully saved."
    Then I follow "back to project page"
    Then I follow "Send Message to Email List"
    And I should see "Draft Update on the project, again!"
    When I follow "Draft Update on the project, again!"
    And I should see "Some very different text."
    And I should see "someone@example.com"

  @shouldwork
  Scenario: CP Sends Mailing List Email
    Given there is a project
    And that project has a CP named "John Smith"
    And I am logged in as "John Smith"
    When I view that project
    And "someone@example.com" is subscribed to the mailing list for that project
    Then I should see "Send Message to Email List"
    When I follow "Send Message to Email List"
    And I fill in "BCC" with "someone@example.com"
    And I fill in "SUBJECT" with "Update on the project!"
    And I fill in "MESSAGE" with "Here is an update on the project."
    And I press an image button with name "send"
    And delayed job runs
    Then "someone@example.com" should receive a Mailing List email
    And that email should have the subject "Update on the project!"
    And "someone@example.com" should receive a Mailing List email
    And that email should have the subject "Update on the project!"
