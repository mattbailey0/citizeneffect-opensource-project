Feature: RegularPages
  In order to manage RegularPages
  As an admin
  I want to create, view, edit, destroy, preview, and publish pages

  @shouldwork
  Scenario: Citizen Effect admin creates a draft regular page
    Given I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I click "Website Pages"
    And "Regular Pages" is currently highlighted
    And I click "(+) Add New Page"
    And I fill in "Title" with "Test Title"
    And I fill in "Permalink (letters, numbers, and dashes (-) only)" with "About_Us"
    And I fill in "Meta Keywords (optional)" with "projects,awesome"
    And I fill in "Meta Description (optional)" with "here is how projects work"
    And I fill in "Content" with "Sample Content"
    And I press "Save as Draft"
    Then I should see "regular page added as draft"
    And I should see "Test Title"
    And I should see "About_Us"

  @shouldwork @js
  Scenario: Citizen Effect admin creates a published regular page
    Given I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I click "Website Pages"
    And "Regular Pages" is currently highlighted
    And I click "(+) Add New Page"
    Then I should see "New Regular Page"
    When I fill in "Title" with "Test Title"
    And I fill in "Permalink (letters, numbers, and dashes (-) only)" with "About_Us"
    And I fill in "Meta Keywords (optional)" with "projects,awesome"
    And I fill in "Meta Description (optional)" with "here is how projects work"
    And I fill in "Content" with "Sample Content"
    And I press "Save & Publish"
    And I confirm
    Then I should see "regular page published"
    And I should see "Test Title"
    And I should see "About_Us"
    When I click the regular page url ending in "About_Us"
    Then I should see "Test Title"
