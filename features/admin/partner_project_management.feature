Feature: Partner Project Management
  In order to keep projects up to date
  As a partner (partner_admin)
  I want to manage project proposals and updates

  @shouldwork
  Scenario: Partner Admin Creates Project Proposal
    Given I am logged in as a partner admin for "SEWA"
    And I am on the dashboard
    # This is a rename of the Phase 1 link "New Project"
    When I click "(+) New Project Proposal"
    Then I should see "SEWA"
    When I fill in "Name" with "Build a SEWA well"
    And I select "Medium" from "Priority"
#    And I fill in "Permalink" with "build-a-sewa-well"
    And I fill in "Primary Objective" with "To build a well in India serving 5000 people"
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
    Then I should see "Project proposal was successfully created."
    And I press "Update"
    And I go to the admin projects page
    Then I should see "Build a SEWA well"

  @shouldwork
  Scenario: Citizen Effect Admin Marks Project Proposal as Requiring More Information
    Given I am logged in as a "citizen_effect_admin"
    And there is a Partner with the name "SEWA"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Approval Process"
    And that project has the name "Example Well Project Awaiting Approval"
    When I go to the admin projects page
    Then I should see "Example Well Project Awaiting Approval"
    When I follow "Show"
    And I follow "View Proposal"
    And I fill in "What's missing?" with "Budget needs to be uploaded"
    And I press "Send back to Partner"
    Then I should see "Project proposal was successfully updated."
    And I should see "Needs More Information"

  @shouldwork
  Scenario: Partner Admin Updates Project Proposal
    Given there is a Partner with the name "SEWA"
    And I am logged in as an admin for partner "SEWA"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Needs More Information"
    And that project has the name "Example Well Project Needing More Info"
    When I go to the admin projects page
    Then I should see "Example Well Project Needing More Info"
    When I follow "Show"
    And I follow "View Proposal"
    And I follow "Edit"
    And I upload a pdf to "Detailed Budget"
    And I press "Update"
    Then I should see "Project proposal was successfully updated."
    Then I should see "Example Well Project"
    Then I should see "pdf"

  @shouldwork
  Scenario: Partner Admin Creates Project Status Update
    Given there is a Partner with the name "SEWA"
    And I am logged in as an admin for partner "SEWA"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Awaiting Cp"
    And that project has the name "Example Well Project That's Available"
    When I go to the admin projects page
    Then I should see "Example Well Project That's Available"
    When I follow "Show"
    Then I should see "New Status Update"
    When I follow "New Status Update"
    And I fill in "Title of Status Update*" with "This is an example status update"
    And I fill in "Updates from the Field" with "This is an example update from the field"
    And I press "Add Status Update"
    Then I should see "Partner Project Status Update was successfully created."
    And I should see "Edit"
    When I follow "Edit"
    Then I should see "Edit Status Update"

  @shouldwork
  Scenario: Partner Admin Creates Project Status Update
    Given there is a Partner with the name "SEWA"
    And I am logged in as an admin for partner "SEWA"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Awaiting Cp"
    And that project has the name "Example Well Project That's Available"
    When I go to the admin projects page
    Then I should see "Example Well Project That's Available"
    When I follow "Show"
    Then I should see "New Status Update"
    When I follow "New Status Update"
    And I fill in "Title of Status Update" with "This is an example status update"
    And I fill in "Updates from the Field" with "This is an example update from the field"
    And I press "Add Status Update"
    Then I should see "Partner Project Status Update was successfully created."
    And I should see "Edit"
    When I follow "Edit"
    Then I should see "Edit uploads for partner project status update"
    When I go to that status update's media album
    Then I should see "Editing Media Album associated with"


  @shouldwork
  Scenario: Partner Admin Updates Project Status Update
    Given there is a Partner with the name "SEWA"
    And I am logged in as an admin for partner "SEWA"
    And there is a project 
    And that project has one status update report
    And that project is partners with "SEWA"
    And that project has status "Awaiting Cp"
    And that project has the name "Example Well Project That's Available"
    When I go to the admin projects page
    Then I should see "Example Well Project That's Available"
    When I follow "Show"
    When I follow a link with class "report_edit"
    And I fill in "Title of Status Update*" with "This is an example changed status update"
    And I press "Update Status Update"
    Then I should see "Partner Project Status Update was successfully updated."

  @shouldwork
  Scenario: Partner Admin Removes Project Status Update
    Given there is a Partner with the name "SEWA"
    And I am logged in as an admin for partner "SEWA"
    And there is a project 
    And that project has one status update report
    And that project is partners with "SEWA"
    And that project has status "Awaiting Cp"
    And that project has the name "Example Well Project That's Available"
    When I go to the admin projects page
    Then I should see "Example Well Project That's Available"
    When I follow "Show"
    Then I should see "Destroy"
    When I follow "Destroy"
    And I confirm
    Then I should see "Partner Project Status Update was successfully removed."

  @shouldwork
  Scenario: Partner Admin Creates Project Progress Report
    Given there is a Partner with the name "SEWA"
    And I am logged in as an admin for partner "SEWA"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Under Construction"
    And that project has the name "Example Well Project Under Construction"
    When I go to the admin projects page
    Then I should see "Example Well Project Under Construction"
    When I follow "Show"
    Then I should see "Add Progress Report"
    When I follow "Add Progress Report"
    And I fill in the selected date for "Start Date" with "2009-10-01"
    And I fill in the selected date for "Expected Completion Date" with "2010-10-10"
    And I fill in "What Has Been Constructed to Date" with "Lots of stuff constructued"
    And I fill in "What Has Been Purchased for the Project" with "Lots of stuff purchased"
    And I fill in "Total # Jobs Created" with "500"
    And I fill in "Description and breakdown of jobs" with "This is a great breakdown of all the jobs"
    And I fill in "Total # Lives Directly Impacted" with "250"
    And I fill in "Direct Impact/Primary Benefits" with "These are the primary benefits"
    And I fill in "Total # Lives Indirectly Impacted" with "5000"
    And I fill in "Community-wide Impact/Extended Benefits" with "These are the extended benefits"
    And I press "Add Progress Report"
    Then I should see "Partner Project Progress Report was successfully created."
    And I should see "Edit"
    When I follow "Edit"
    Then I should see "Edit Progress Report"
    And I should see "Edit uploads for partner project progress report"
    When I go to that progress report's media album
    Then I should see "Editing Media Album associated with"

  @shouldwork
  Scenario: Citizen Effect Admin Approves Progress Report
    Given I am logged in as a "citizen_effect_admin"
    And there is a Partner with the name "SEWA"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Under Construction"
    And that project has the name "Example Well Project Under Construction"
    And that project has a progress report
    And that progress report has status "Awaiting Approval"
    When I go to the admin projects page
    Then I should see "Example Well Project Under Construction"
    When I follow "Show"
    When I follow a link with class "report_link"
    And I fill in "What's the next step?" with "This is the next step."
    And I press "Approve Now"
    Then I should see "Approval sent."

  @shouldwork @gwip
  Scenario: Partner Admin Creates Project Final Report
    Given there is a Partner with the name "SEWA"
    And I am logged in as an admin for partner "SEWA"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Construction Complete"
    And that project has the name "Example Well Project Construction Completed"
    When I go to the admin projects page
    Then I should see "Example Well Project Construction Completed"
    When I follow "Show"
    Then I should see "Add Final Report"
    When I follow "Add Final Report"
    And I fill in the selected date for "Start Date" with "2009-10-01"
    And I fill in the selected date for "Expected Completion Date" with "2010-10-10"
    And I fill in "What Has Been Purchased for the Project" with "Lots of stuff purchased"
    And I fill in "Total # Jobs Created" with "500"
    And I fill in "Description and breakdown of jobs" with "This is a great breakdown of all the jobs"
    And I fill in "Summary of Project Completion" with "We completed this project in record time"
    And I fill in "Total # Lives Directly Impacted" with "250"
    And I fill in "Direct Impact/Primary Benefits" with "These are the primary benefits"
    And I fill in "Total # Lives Indirectly Impacted" with "5000"
    And I fill in "Community-wide Impact/Extended Benefits" with "These are the extended benefits"
    And I press "Add Final Report"
    Then I should see "Partner Project Final Report was successfully created."
    And I should see "Edit"
    When I follow "Edit"
    Then I should see "Edit Final Report"
    And I should see "Edit uploads for partner project final report"
    When I go to that final report's media album
    Then I should see "Editing Media Album associated with"

  @shouldwork
  Scenario: Citizen Effect Admin Approves Project Final Report
    Given I am logged in as a "citizen_effect_admin"
    And there is a Partner with the name "SEWA"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Construction Complete"
    And that project has the name "Example Well Project Construction Completed"
    And that project has a final report
    And that final report has status "Awaiting Approval"
    When I go to the admin projects page
    Then I should see "Example Well Project Construction Completed"
    When I follow "Show"
    When I follow a link with class "report_link"
    And I fill in "What's the next step?" with "This is the next step."
    And I press "Approve Now"
    Then I should see "Approval sent."

  @shouldwork
  Scenario: Partner Admin Creates Project Impact Report
    Given there is a Partner with the name "SEWA"
    And I am logged in as an admin for partner "SEWA"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Construction Complete"
    And that project has the name "Example Well Project Construction Completed"
    When I go to the admin projects page
    Then I should see "Example Well Project Construction Completed"
    When I follow "Show"
    Then I should see "New Impact Report"
    When I follow "New Impact Report"
    And I fill in "Total # Lives Directly Impacted" with "250"
    And I fill in "Direct Impact/Primary Benefits" with "These are the primary benefits"
    And I fill in "Total # Lives Indirectly Impacted" with "5000"
    And I fill in "Community-wide Impact/Extended Benefits" with "These are the extended benefits"
    And I fill in "Education & Nutrition" with "The nutrition improved by 50%"
    And I press "Add Impact Report"
    Then I should see "Partner Project Impact Report was successfully created."
    And I should see "Edit"
    When I follow "Edit"
    Then I should see "Edit Impact Report"
    And I should see "Edit uploads for partner project impact report"
    When I go to that impact report's media album
    Then I should see "Editing Media Album associated with"

  @shouldwork
  Scenario: Citizen Effect Admin Approves Project Impact Report
    Given I am logged in as a "citizen_effect_admin"
    And there is a Partner with the name "SEWA"
    And there is a project 
    And that project is partners with "SEWA"
    And that project has status "Construction Complete"
    And that project has the name "Example Well Project Construction Completed"
    And that project has "1" impact report
    And that impact report has status Awaiting Approval
    When I go to the admin projects page
    Then I should see "Example Well Project Construction Completed"
    When I follow "Show"
    When I follow a link with class "report_link"
    And I fill in "What's the next step?" with "This is the next step."
    And I press "Approve Now"
    Then I should see "Approval sent."
