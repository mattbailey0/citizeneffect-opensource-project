Feature: Project's Photo Albums
  In order to more fully showcase the project  
  As a Citizen Philanthropist
  I want to manage the project's photo albums

  @1
  Scenario: CP Creates Photo Album linked to an Event and Uploads Photo
    Given I am logged in as "John Smith"
    And there is a user named "John Smith" 
    And there is a project
    And that project has a CP named "John Smith"
    And that project has an event
    When I view that project
    Then I should see "View Media Gallery"
    When I follow "View Media Gallery"
    Then I should see "Manage Albums"
    When I follow "Manage Albums"
    Then I should see "Add a New Album"
    When I follow "Add a New Album"
    And I fill in "Album Name" with "Wild and Crazy Pictures"
    And I fill in "Add Another File" with "test_pic.png"
    And I press "Save & Upload"
    Then I should see "Album Created"
    And I fill in "Title" with "Wild and Crazy Caption"
    And I press "Save & Upload"
    Then I should see "Wild and Crazy Caption"
    And I should see "Wild and Crazy Pictures"
    When I view that project
    Then I should see "View Media Gallery"
    When I follow "View Media Gallery"
    Then I should see "Wild and Crazy Pictures"
    When I follow "An Event" without refreshing the page
    Then I should see the name of that event
    And I check the name of that event
    And I press "Save & Upload"
    When I view that event page
    Then I should see "Wild and Crazy Pictures"

  @1
  Scenario: CP Edits Name of and Uploads Photo to Existing Album
    Given I am logged in as "John Smith"
    And there is a user named "John Smith" 
    And there is a project
    And that project has a CP named "John Smith"
    And that project has a photo album
    When I view that project
    Then I should see "View Media Gallery"
    When I follow "View Media Gallery"
    Then I should see "Manage Albums"
    When I follow "Manage Albums"
    Then I should see "Edit this Album"
    When I follow "Edit this Album"
    And I fill in "Album Name" with "Updated Wild and Crazy Pictures"
    And I fill in "Add Another File" with "test_pic.png"
    And I press "Save & Upload"
    Then I should see "Album Updated"
    And I fill in "Title" with "Yet Another Wild and Crazy Caption"
    And I press "Save & Upload"
    Then I should see "Yet Another Wild and Crazy Caption"
    And I should see "Updated Wild and Crazy Pictures"
    When I view that project
    Then I should see "View Media Gallery"
    When I follow "View Media Gallery"
    Then I should see "Updated Wild and Crazy Pictures"

  @1  
  Scenario: CP Removes Photo in Existing Album
    Given I am logged in as "John Smith"
    And there is a user named "John Smith" 
    And there is a project
    And that project has a CP named "John Smith"
    And that project has a photo album
    And that photo album has a picture
    When I view that project
    Then I should see "View Media Gallery"
    When I follow "View Media Gallery"
    Then I should see "Manage Albums"
    When I follow "Manage Albums"
    Then I should see "Edit this Album"
    When I follow "Edit this Album"
    Then I should see "Remove Picture"
    When I follow "Remove Picture"
    Then I should see "Picture Removed from Album"

  @1  
  Scenario: CP Removes Photo Album
    Given I am logged in as "John Smith"
    And there is a user named "John Smith" 
    And there is a project
    And that project has a CP named "John Smith"
    And that project has a photo album
    When I view that project
    Then I should see "View Media Gallery"
    When I follow "View Media Gallery"
    Then I should see "Manage Albums"
    When I follow "Manage Albums"
    Then I should see "Remove Album"
    When I follow "Remove Album"
    Then I should see "Album Removed"
    When I view that project
    Then I should see "View Media Gallery"
    When I follow "View Media Gallery"
    Then I should not see the name of that photo album


