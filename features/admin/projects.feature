Feature: Projects
  In order to track projects
  As an admin
  I want to create projects and edit their details

  @shouldwork
  Scenario: Citizen Effect admin creates a project
    Given I am logged in as a "citizen_effect_admin"
    And there is a Partner with the name "SEWA"
    And I go to the dashboard
    When I click "(+) New Project"
    And I fill in "Name" with "Build a well"
    And I select "SEWA" from "Partner"
    And I fill in "Community Leader" with "David Hasselhof"
    And I fill in "District Coordinator" with "Lance Armstrong"
    And I fill in "Justification for Project" with "קטגוריה 1"
    And I fill in "What will be done" with "A well will be built.  Not just any well.  A *whale* of a well!"
    And I fill in "Summary for Website" with "We are going to build a *whale* of a well."
    And I select "Peru" from "Country"
    And I fill in "Primary Objective" with "Help all Humans"
    And I fill in "Total # Lives Directly Impacted" with "100"
    And I fill in the selected date for "Desired Construction Start Date" with "2010-10-08"
    And I fill in "Community Population" with "75"
    And I fill in "Community State" with "Bad?"
    And I fill in "Community Name" with "Umbaziblaz"
    And I fill in "Total # Lives Indirectly Impacted" with "345"
    And I select "ASW" from "Local Currency Type"
    And I fill in "Total Cost in Local Currency" with "34500"
    And I fill in "District Name" with "Umazcakel"
    And I fill in "How will it be done?" with "Sweat of the brow, diesel of the engine, labor of the just."
    And I press "Create Project and Continue Editing"
    Then I should see "Project proposal was successfully created. Please fill in additional details."
    And I press "Update"
    Then I should see "Project proposal was successfully updated."
    And I go to the admin projects page
    Then I should see "Build a well"

  @shouldwork @bugfix
  Scenario: Citizen Effect admin edits a project with donations that have no users associated with them
    Given I am logged in as a "citizen_effect_admin"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Awaiting Cp"
    And that project has the name "Example Well Project That's Available"
    And that project has a donation without an associated user
    When I go to the admin projects page
    Then I should see "Edit"
    When I follow "Edit"
    Then I should see "Update"
    When I press "Update"
    Then I should see "Project proposal was successfully updated."

  @shouldwork
  Scenario: Citizen Effect admin adds a primary photo to a draft project
    Given I am logged in as a "citizen_effect_admin"
    And there is a project
    And that project is partners with "SEWA"
    And that project has status "Draft"
    And that project has the name "Pew Pew Sharks in India!"
    When I go to the admin projects page
    And I follow "Edit"
    Then I should see "Edit featured media"
    When I view that project's featured media page
    Then I should see an image link with class "change_primary_photo"
    When I click an image link with class "change_primary_photo"
    Then I should see "UPLOAD FEATURED PROJECT MEDIA"
    When I upload an image to a file field with class "upload_file_field"
    And I fill in "Title" with "Jaws 19 Poster"
    And I fill in "Description" with "Jaws 19 Posters are a rare commodity and not to be found by people with normal constitutions. Should you ever see one in person, grab it and hold on for dear life."
    And I press an image button with class "image_upload_button"
    Then I should see "Jaws 19 Poster"
    And I should see "Jaws 19 Posters are a rare commodity"

  @shouldwork @bugfix
  Scenario: Citizen Effect admin edits a project with donations that have no users associated with them
    Given I am logged in as a "citizen_effect_admin"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Draft"
    And that project has the name "Example Well Project That's Available"
    And that project does not have an approved at time
    When I go to the admin projects page
    Then I should see "Edit"
    When I follow "Edit"
    And I select "Awaiting Cp" from "Status"
    And I should see "Update"
    When I press "Update"
    Then I should see "Project proposal was successfully updated."
    Then that project should have an approved at time
    
