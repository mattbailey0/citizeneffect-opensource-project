Feature: CPs
  In order to manage CPs
  As an admin
  I want to view, edit, and remove CP status

  @shouldwork
  Scenario: Citizen Effect admin makes a user a CP
    Given I am logged in as a "citizen_effect_admin"
    And there is a user named "test user"
    And that user has the email "test@example.com"
    And I am on the dashboard
    When I click "CPs"
    And I click "Grant User CP Status"
    And I select "test user (test@example.com)" from "Select User Account"
    And I press "Grant CP Status"
    Then I should see "User and Role Association was successfully created"

  @shouldwork @js
  Scenario: Citizen_Effect admin revokes CP status
    Given I am logged in as a "citizen_effect_admin"
    And there is a "cp" user with email "cp@example.com" and password "password"
    And I am on the CP list page
    When I click "Destroy"
    And I confirm
    Then I should not see "cp@example.com"
