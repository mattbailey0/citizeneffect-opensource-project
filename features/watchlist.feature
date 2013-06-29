Feature: Watchlist
  In order to more easily keep track of projects I'm interested in
  As an End User
  I want manage my watchlist

  @shouldfail @2
  Scenario: Add to Watchlist from Homepage as Anonymous User
    Given I am not logged in
    And there is a user visible project with name "Wild And Crazy Well Project in Village"
    When I view that project
    Then I should see "add to watch list"
    When I click "add to watch list"
    Then I should see "In order to apply to watch projects, please create an account."
    When I fill in "First name" with "Biz"
    And I fill in "Last name" with "Stone"
    And I fill in "Email" with "someuser@example.com"
    And I fill in "Zip Code" with "94101"
    And I fill in "Password" with "secret"
    And I fill in "Confirm Password" with "secret"
    And I press "Sign up"
    Then I should receive a User Signup Notification email
    When I open the email
    Then I should see "Citizen Effect - Please activate your new account" in the subject
    When I click the first link in the email
    Then I should see "Account signup is complete."
    Then I should see "remove from watch list"
    # punt punt punt - this is where there would be a facebox
    And I should see "You're Successfully Watching"
    And I should see "Other Projects You Might Like"
    
  @shouldfail @2
  Scenario: Add to Watchlist from Project Page as Logged In User
    Given I am logged in as "Jane Doe"
    And there is a user visible project with name "Wild And Crazy Well Project in Village"
    When I view that project
    Then I should see "add to watch list"
    When I click "add to watch list"
    And I wait for the AJAX call to finish
    Then I should see "remove from watch list"
    # punt punt punt - this is where there would be a facebox
    And I should see "You're Successfully Watching"
    And I should see "Other Projects You Might Like"
  
  @shouldfail @2
  Scenario: Add to Watchlist from Project Index Page as Logged In User
    Given I am logged in as "Jane Doe"
    And there is a user visible project with name "Wild And Crazy Well Project in Village"
    When I go to the projects page
    Then I should see "add to watch list"
    When I click "add to watch list"
    And I wait for the AJAX call to finish
    Then I should see "remove from watch list"
    # punt punt punt - this is where there would be a facebox
    And I should see "You're Successfully Watching"
    And I should see "Other Projects You Might Like"

  @shouldwork
  Scenario: View Watchlist
    Given I am logged in as "Jane Doe"
    And there is a project named "Wild And Crazy Well Project in Village"
    And that project is on my watchlist
    When I go to the homepage
    Then I should see "Watch List"
    When I follow "Watch List"
    Then I should see "Wild And Crazy Well Project in Village"
    Then I should see an image link for that project with class "stop_watching_project"
  
  @shouldwork
  Scenario: Remove Project from Watchlist
    Given I am logged in as "Jane Doe"
    And there is a project named "Wild And Crazy Well Project at Farm"
    And that project is on my watchlist
    When I go to the homepage
    Then I should see "Watch List"
    When I follow "Watch List"
    Then I should see "Wild And Crazy Well Project at Farm"
    Then I should see an image link for that project with class "stop_watching_project"
    When I follow that image link
    Then I should see "Project removed from Watch List"
    And I should not see the name of that project in my watchlist


