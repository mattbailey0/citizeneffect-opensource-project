Feature: Citizen Philanthropist Application
  In order to manage Citizen Philanthropist(CP) Applications
  As a Citizen Effect Admin
  I want to review, approve, and deny CP Applications

  @shouldwork
  Scenario: Citizen Effect Views an approved CP Application
    Given I am logged in as a "citizen_effect_admin"
    And there is an approved CP Application for "Niklas Albrecht"
    And I am on the dashboard
    Then I should see "CP Applications"
    When I follow "CP Applications"
    Then I should see "Show"
    When I follow "Show"
    Then I should see "CP Application is Approved"
    When I follow "CPs"
    Then I should see "Niklas"
    And I should see "Albrecht"
    
  @shouldwork
  Scenario: Citizen Effect Views a denied CP Application
    Given I am logged in as a "citizen_effect_admin"
    And there is a denied CP Application for "Niklas Albrecht"
    And I am on the dashboard
    Then I should see "CP Applications"
    When I follow "CP Applications"
    Then I should see "Show"
    When I follow "Show"
    Then I should see "CP Application is Denied"
    When I follow "CPs"
    Then I should not see "Niklas"
    And I should not see "Albrecht"

  @shouldwork
  Scenario: Citizen Effect Admin Approves CP Application
    Given I am logged in as a "citizen_effect_admin"
    And there is a CP Application for a Project for "Niklas Albrecht"
    And I am on the dashboard
    Then I should see "CP Applications"
    When I follow "CP Applications"
    Then I should see "Show/Approve/Deny"
    When I follow "Show/Approve/Deny"
    And I fill in "Notes" with "Go get 'em!"
    And I press "Approve Now"
    Then I should see "Approval sent."
    When I follow "CPs"
    Then I should see "Niklas"
    And I should see "Albrecht"
    #And "Niklas Albrecht" should receive a CP Application approved email

  @shouldwork
  Scenario: Citizen Effect Admin Declines CP Application
    Given I am logged in as a "citizen_effect_admin"
    And there is a CP Application for a Project for "Niklas Albrecht"
    And I am on the dashboard
    Then I should see "CP Applications"
    When I follow "CP Applications"
    Then I should see "Show/Approve/Deny"
    When I follow "Show/Approve/Deny"
    And I fill in "Why?" with "You're doing too many projects already."
    And I press "Deny"
    Then I should see "Denial sent."
    When I follow "CPs"
    Then I should not see "Niklas"
    And I should not see "Albrecht"
    #And "Niklas Albrecht" should receive a CP Application denied email
