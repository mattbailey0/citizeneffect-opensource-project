Feature: Project's YouTube Videos
  In order to more fully showcase the project  
  As a Citizen Philanthropist
  I want to manage the project's youtube videos
  
  Scenario: CP Adds Video to Project with an Event
    Given I am logged in as "John Smith"
    And there is a user named "John Smith" 
    And there is a project
    And that project has a CP named "John Smith"
    When I view that project
    Then I should see "View Media Gallery"
    When I follow "View Media Gallery"
    Then I should see "Manage Videos"
    When I follow "Manage Videos"
    And I fill in "YouTube Video URL" with "http://www.youtube.com/"
    When I follow "An Event" without refreshing the page
    Then I should see the name of that event
    And I check the name of that event
    When I press "Add Video"
    Then I should see "Video Added"
    And I should see "Evolution of Dance"
    When I view that project
    Then I should see "View Media Gallery"
    When I follow "View Media Gallery"
    Then I should see "Evolution of Dance"
    When I view that event page
    Then I should see "Evolution of Dance"
    
  Scenario: CP Removes Video from Project
    Given I am logged in as "John Smith"
    And there is a user named "John Smith" 
    And there is a project
    And that project has a video
    And that project has a CP named "John Smith"
    When I view that project
    Then I should see "View Media Gallery"
    When I follow "View Media Gallery"
    Then I should see "Manage Videos"
    When I follow "Manage Videos"
    Then I should see the name of that video
    And I should see "Remove Video"
    When I follow "Remove Video"
    Then I should see "Video Removed"
    And I should not see the name of that video
