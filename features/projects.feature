Feature: Projects
  In order to browse projects  
  As a visitor
  I want to navagate between pages and see appropriate updates

  @shouldwork
  Scenario: Recently viewed projects gets updated
    Given there is a user visible project with name "Build a Well"
    And a project with a cp
    And I haven't been to the site before
    When I go to the projects page
    Then I should not see "Build a Well" with class "recently_viewed_projects"
    When I go to the "Build a Well" project page
    And I go to the projects page
    Then I should see "Build a Well" with class "recently_viewed_projects"

  @shouldwork
  Scenario: Additional community member details show up when filled in and unhidden on page
    Given there is a user visible project with name "Build a Well"
    And that project has a CP named "John Smith"
    And that project has "community_summary_for_website" set to "home of the dark knight"
    And that project has "brief_history_of_community" set to "it's been around"
    And that project has "community_name" set to "gotham city"
    When I view that project
    And I click a link with id "btn_community_details"
    And I wait for the AJAX call to finish
    Then I should see "it's been around" with id "info_box_community_details"
    # look for class hidden since htmlunit doesn't handle stylesheet visibility
    And I should see "it's been around" with class "hidden"
    When I click "Learn more about gotham city"
    Then I should not see "it's been around" with class "hidden"
    And I should see "it's been around" with id "more_project_community_details_box"

  @shouldwork
  Scenario: Anonymous User Donates to Project, Joins Mailing List, and Creates An Account
    Given I am logged out
    And there is a project named "Donation Test 1"
    And that project is user visible
    And that project has a CP
    And that project has a total cost of "200" dollars
    When I go to the needing donations rss feed
    Then the page should match "Donation Test 1"

  @shouldwork
  Scenario: Anonymous User Donates to Project, Joins Mailing List, and Creates An Account
    Given I am logged out
    And there is a project named "Needing CP test 1"
    And that project is user visible
    When I go to the needing a cp rss feed
    Then the page should match "Needing CP test 1"
