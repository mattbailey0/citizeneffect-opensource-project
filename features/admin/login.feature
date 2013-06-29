Feature: Admin Login
  In order to login
  As an admin
  I want to login

  @shouldwork
  Scenario: Enter credentials and submit
    Given I am logged out
    And there is a "citizen_effect_admin" user with email "admin@example.com" and password "password"
    And I go to the homepage
    Then I should see "login"
    And I fill in "login" with "admin@example.com"
    And I fill in "password" with "password"
    And I press the login button
    Then I should see "Logged in successfully"
