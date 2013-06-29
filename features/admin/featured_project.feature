Feature: Featured Project
  In order to manage Featured Projects
  As a Citizen Effect Admin
  I want to review featured projects, add featured projects, edit featured projects, and remove featured projects from public view

  @shouldwork
  Scenario: Citizen Effect Views a Featured Project in the admin interface and public interface
    Given there is a featured project
    And I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    Then I should see "Homepage Features"
    When I follow "Homepage Features"
    Then I should see "Listing Featured Projects"
    And I should see "Show"
    When I follow "Show"
    Then I should see "Featured Farm Project"
    Given I am logged out
    And I am on the homepage
    And there is a featured project
    Then I should see "Featured Farm Project"

  @shouldwork
  Scenario: Citizen Effect Adds a Featured Project
    Given I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I follow "Homepage Features"
    Then I should see "(+) Add Featured Project"
    When I follow "(+) Add Featured Project"
    Then I should see "New Featured Project"
    When I fill in "Title" with "Zejari Village, India"
    And I fill in "Caption" with "Ashvin is a 9-year old boy living in poverty because his family's farm is failing."
    And I fill in "Url identifier" with "http://www.google.com"
    And I upload an image to "Large Picture"
    And I upload an image to "Thumbnail (67x67)"
    And I press "Create"
    And I confirm
    Then I should see "Listing Featured Projects"
    And I should see "Featured Project was successfully added."

    Given I am logged out
    And I am on the homepage
    Then I should see "Zejari Village, India"
    And I should see "Ashvin is a 9-year old boy living in poverty because his family's farm is failing."

  @shouldwork
  Scenario: Citizen Effect Removes a Featured Project
    Given there is a featured project
    And I am logged out
    And I am on the homepage
    Then I should see "Featured Farm Project"

    Given I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I follow "Homepage Features"
    And I click "Destroy"
    And I confirm
    Then I should see "Featured Project was successfully removed."
    
    Given I am logged out
    And I am on the homepage
    And there is a featured project
    Then I should not see "Featured Farm Project"

  @shouldwork
  Scenario: Citizen Effect Edits a Featured Project
    Given there is a featured project
    And I am logged out
    And I am on the homepage
    Then I should see "Featured Farm Project"

    Given I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I follow "Homepage Features"
    And I click "Edit"
    Then I should see "Editing Featured Project"
    When I fill in "Title" with "Updated Featured Farm Project"
    And I press "Update"
    And I confirm
    Then I should see "Listing Featured Projects"
    And I should see "Featured Project was successfully updated."

    Given I am logged out
    And I am on the homepage
    And there is a featured project
    Then I should see "Updated Featured Farm Project"


  @shouldwork
  Scenario: Featured Project shouldn't be created if any fields are left out
    Given I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I follow "Homepage Features"
    Then I should see "(+) Add Featured Project"
    When I follow "(+) Add Featured Project"
    Then I should see "New Featured Project"
    And I press "Create"
    And I confirm
    Then I should see "New Featured Project"
    And I should see "Title can't be blank"
    And I should see "Picture thumbnail can't be blank"
    And I should see "Caption can't be blank"
    And I should see "Picture can't be blank"
    And I should see "Url identifier can't be blank"
