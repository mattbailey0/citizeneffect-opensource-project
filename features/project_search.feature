Feature: Project Search
  In order to efficiently find projects I'm interested in
  As an End User
  I want to search all projects
  
  @shouldwork
  Scenario: Searching by Project Name
    Given I am not logged in
    And there is a user visible project with name "Wild And Crazy Well Project in Village" 
    And search indexing runs
    When I go to the projects page
    And I search for "Wild And Crazy" 
    Then I should see "Wild And Crazy" in class "search-results"

  @shouldwork
  Scenario: Searching with Pagination
    Given I am not logged in
    And there is a user visible project with name "Wild 1"
    And there is a user visible project with name "Wild 2" 
    And there is a user visible project with name "Wild 3" 
    And there is a user visible project with name "Wild 4" 
    And there is a user visible project with name "Wild 5" 
    And there is a user visible project with name "Wild 6" 
    And there is a user visible project with name "Wild 7" 
    And there is a user visible project with name "Wild 8" 
    And there is a user visible project with name "Wild 9" 
    And there is a user visible project with name "Wild 10" 
    And there is a user visible project with name "Wild 11" 
    And there is a user visible project with name "Wild 12" 
    And there is a user visible project with name "Wild 13" 
    And there is a user visible project with name "Wild 14" 
    And there is a user visible project with name "Wild 15" 
    And there is a user visible project with name "Wild 16" 
    And there is a user visible project with name "Wild 17" 
    And there is a user visible project with name "Wild 18" 
    And there is a user visible project with name "Wild 19" 
    And there is a user visible project with name "Wild 20" 
    And there is a user visible project with name "Wild 21" 
    And search indexing runs
    When I go to the projects page
    And I search for "Wild"
    Then I should see "Wild 1" in class "search-results"
    And I should see "Wild 20" in class "search-results"
    And I should not see "Wild 21" in class "search-results"
    And I should see "1" in class "pagination"
    And I should see "2" in class "pagination"
    When I follow "Next"
    Then I should see "Wild 21" in class "search-results"
    And I should not see "Wild 1" in class "search-results"

  @shouldfail @2
  Scenario: Searching by CP Name
    Given I am not logged in
    And there is a project 
    And that project has a CP named "John Smith"
    When I go to the projects page
    And I select "Users" from "All Projects"
    And I search for "John"
    Then I should see that Project in the search results
    When I search for "Smith"
    Then I should see that Project in the search results

  @shouldfail @2
  Scenario: Filtering by Country
    Given I am not logged in
    And there is a Project
    And that project is in the Country "India"
    When I go to the projects page
    And I follow "Advanced Search" without refreshing the page # Not sure how to signify AJAX links
    And I check "India" # Not sure how to check a box
    And I follow "View Results" without refreshing the page # Not sure how to signify AJAX links
    Then I should see that Project in the search results

  @shouldfail @2
  Scenario: Filtering by Lives Impacted
    Given I am not logged in
    And there is a project 
    And that project has Primary Lives Impacted "50"
    When I go to the projects page
    And I follow "Advanced Search" without refreshing the page # Not sure how to signify AJAX links
    And I check "0-500" # Not sure how to check a box
    And I follow "View Results" without refreshing the page # Not sure how to signify AJAX links
    Then I should see that Project in the search results

  @shouldfail @2
  Scenario: Filtering by Focus Area
    Given I am not logged in
    And there is a project 
    And that project has Focus Area "Water & Sanitation"
    When I go to the projects page
    And I follow "Advanced Search" without refreshing the page # Not sure how to signify AJAX links
    And I check "Water & Sanitation" # Not sure how to check a box
    And I follow "View Results" without refreshing the page # Not sure how to signify AJAX links
    Then I should see that Project in the search results

  @shouldfail @2
  Scenario: Filtering by Total Cost
    Given I am not logged in
    And there is a project 
    And that project has a total cost of "6500" dollars
    When I go to the projects page
    And I follow "Advanced Search" without refreshing the page # Not sure how to signify AJAX links
    And I check "$5,001-$10,000" # Not sure how to check a box
    And I follow "View Results" without refreshing the page # Not sure how to signify AJAX links
    Then I should see that Project in the search results

  @shouldfail @2
  Scenario: Filtering by Status
    Given I am not logged in
    And there is a project 
    And that project is completed
    When I go to the projects page
    And I follow "Advanced Search" without refreshing the page # Not sure how to signify AJAX links
    And I check "Completed Projects" # Not sure how to check a box
    And I follow "View Results" without refreshing the page # Not sure how to signify AJAX links
    Then I should see that Project in the search results

  @shouldfail @2
  Scenario: Filtering by Status and Search by CP Name
    Given I am not logged in
    And there is a project 
    And that project is completed
    And that project has a CP named "John Smith"
    When I go to the projects page
    And I select "Users" from "All Projects"
    And I search for "John"
    And I follow "Advanced Search" without refreshing the page # Not sure how to signify AJAX links
    And I check "Completed Projects" # Not sure how to check a box
    And I follow "View Results" without refreshing the page # Not sure how to signify AJAX links
    Then I should see that Project in the search results
  
