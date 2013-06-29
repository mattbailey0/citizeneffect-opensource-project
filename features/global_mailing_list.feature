Feature: Global Mailing List
  In order to receive updates
  As a visitor of the site
  I want to join the mailing list

  @shouldwork
  Scenario: CE Sends Mailing List Email
    Given I am logged in as a "citizen_effect_admin"
    And "someone@example.com" is subscribed to the global mailing list
    When I am on the dashboard
    And I click "Mailing List"
    Then I should see "CREATE A NEW EMAIL"
    When I fill in "BCC" with "someone@example.com"
    And I fill in "SUBJECT" with "CE Update!"
    And I fill in "MESSAGE" with "Here is an update on the project."
    And I press an image button with name "send"
    Then I should see "Email was successfully sent."
    When delayed job runs
    Then "someone@example.com" should receive a Mailing List email
    And that email should have the subject "CE Update!"

  @shouldwork
  Scenario: Anonymous user subscribes to global mailing list from a campaign email
    Given I am not logged in
    # project for thanks page
    And there is a project
    And that project is user visible
    And that project has a CP
    And that project has a total cost of "200" dollars
    When I click a campaign email link with tracking code "eschelon"
    Then I should see "START MAKING A REAL DIFFERENCE RIGHT NOW"
    When I fill in "FIRST NAME" with "Billy"
    And I fill in "LAST NAME" with "Joe"
    And I fill in "E-MAIL" with "someone@example.com"
    And I fill in "ZIPCODE" with "12345"
    And I press an image button with class "join_the_movement"
    Then I should see "THANK YOU FOR BEING PART OF OUR COMMUNITY!"
    When I click "Create"
    Then I should see "ACCOUNT SIGN UP"
    When I go back
    And I click "Search"
    Then I should see "Answer a few simple"
    When I go back
    And I click "Apply"
    # since we're not signed in
    Then I should see "ACCOUNT SIGN UP"
    When I go back
    And I click "Donate"
    Then I should see "DONATE TO"
    When I go back
    And I click an image link with class "mailing_list_users_donate"
    Then I should see "DONATE TO"
    Given I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I click "Subscribers"
    Then I should see "eschelon"

  @shouldwork
  Scenario: Anonymous user subscribes to global mailing list twice from a campaign email and gets to thanks page
    Given I am not logged in
    # project for thanks page
    And there is a project
    And that project is user visible
    And that project has a CP
    And that project has a total cost of "200" dollars
    When I click a campaign email link with tracking code "eschelon"
    Then I should see "START MAKING A REAL DIFFERENCE RIGHT NOW"
    When I fill in "FIRST NAME" with "Billy"
    And I fill in "LAST NAME" with "Joe"
    And I fill in "E-MAIL" with "someone@example.com"
    And I fill in "ZIPCODE" with "12345"
    And I press an image button with class "join_the_movement"
    Then I should see "THANK YOU FOR BEING PART OF OUR COMMUNITY!"
    When I click a campaign email link with tracking code "eschelon"
    Then I should see "START MAKING A REAL DIFFERENCE RIGHT NOW"
    When I fill in "FIRST NAME" with "Billy"
    And I fill in "LAST NAME" with "Joe"
    And I fill in "E-MAIL" with "someone@example.com"
    And I fill in "ZIPCODE" with "12345"
    And I press an image button with class "join_the_movement"
    Then I should see "THANK YOU FOR BEING PART OF OUR COMMUNITY!"

  @shouldwork @bugfix
  Scenario: Signed up User subscribes to global mailing list first on account create, then three times from a campaign email, changing user's email address between second and third signups, and gets to thanks page all times
    Given there is a user named "Jane Doe"
    And that user has the email "someone@example.com"
    # project for thanks page
    And there is a project
    And that project is user visible
    And that project has a CP
    And that project has a total cost of "200" dollars
    When I click a campaign email link with tracking code "eschelon"
    Then I should see "START MAKING A REAL DIFFERENCE RIGHT NOW"
    When I fill in "FIRST NAME" with "Billy"
    And I fill in "LAST NAME" with "Joe"
    And I fill in "E-MAIL" with "someone@example.com"
    And I fill in "ZIPCODE" with "12345"
    And I press an image button with class "join_the_movement"
    Then I should see "THANK YOU FOR BEING PART OF OUR COMMUNITY!"
    Given that user has the email "someone@example.com"
    When I click a campaign email link with tracking code "eschelon"
    Then I should see "START MAKING A REAL DIFFERENCE RIGHT NOW"
    When I fill in "FIRST NAME" with "Billy"
    And I fill in "LAST NAME" with "Joe"
    And I fill in "E-MAIL" with "someone@example.com"
    And I fill in "ZIPCODE" with "12345"
    And I press an image button with class "join_the_movement"
    Then I should see "THANK YOU FOR BEING PART OF OUR COMMUNITY!"
    When I click a campaign email link with tracking code "eschelon"
    Then I should see "START MAKING A REAL DIFFERENCE RIGHT NOW"
    When I fill in "FIRST NAME" with "Billy"
    And I fill in "LAST NAME" with "Joe"
    And I fill in "E-MAIL" with "someone@example.com"
    And I fill in "ZIPCODE" with "12345"
    And I press an image button with class "join_the_movement"
    Then I should see "THANK YOU FOR BEING PART OF OUR COMMUNITY!"
