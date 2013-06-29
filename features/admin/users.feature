Feature: Users
  In order to manage users
  As a CE Admin
  I want to view and manage users in the admin interface
  
  @shouldwork
  Scenario: Admin activates a user from the admin interface
    Given I am logged in as a "citizen_effect_admin"
    And there is a user named "John Smith"
    And that user is not active
    When I go to the user list page
    Then I should see "John"
    When I click "(activate)"
    Then I should see "User activated!"
    And I should not see "(activate)"
  
  @shouldwork
  Scenario: Admin resets a user's password from the admin interface
    Given I am logged in as a "citizen_effect_admin"
    And there is a user named "John Smith"
    And that user has "email" set to "johnnyboy@example.com"
    When I go to the user list page
    Then I should see "John"
    When I click "Change Password" for "johnnyboy@example.com"
    And I fill in "Password" with "fluffy"
    And I fill in "Password confirmation" with "fluffy"
    And I press "Change Password"
    Then I should see "Password updated!"
    When I am logged out
    And I go to the homepage
    And I fill in "login" with "johnnyboy@example.com"
    And I fill in "password" with "fluffy"
    And I press the login button
    Then I should see "Logged in successfully"
