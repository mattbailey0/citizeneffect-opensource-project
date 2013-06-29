# STUB
# The public output of all of this is not yet created, so we need to make sure stuff we make in this test

Feature: Fundraiser Type
  In order to manage Fundraiser Types
  As a Citizen Effect Admin
  I want to add types, edit types, remove types, attach files to types, tag types, and experience reports to types

  @shouldwork
  Scenario: Citizen Effect Adds a Fundraiser Type
    Given I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I follow "Fundraiser Types"
    Then I should see "(+) Add Fundraiser Type"
    And I should see "Listing Fundraiser Types"
    When I follow "(+) Add Fundraiser Type"
    Then I should see "New Fundraiser Type"
    When I fill in "Name" with "Bake Sale"
    And I fill in "Description" with "Park ourselves in front of a Wal-Mart and sell us some pecan sandies!"
    And I upload an image to "Picture"
    And I fill in "Minimum" with "300"
    And I fill in "Maximum" with "500"
    And I select "Medium" from "Difficulty"
    And I fill in "Tags" with "cooks, chefs"
    And I press "Create"

    Then I should see "Viewing Fundraiser Type"
    And I should see "Bake Sale"
    And I should see "Park ourselves in front of a Wal-Mart and sell us some pecan sandies!"
    And I should see "$300.0 - $500.0"
    And I should see "cooks, chefs"
    And I should see "Fundraiser Type was successfully added."


  @shouldwork
  Scenario: Citizen Effect Edits a Fundraiser Type
    Given there is a fundraiser type named "Bake Sale"
    And I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I follow "Fundraiser Types"
    Then I should see "Edit"
    When I follow "Edit"
    Then I should see "Editing Fundraiser Type"
    When I fill in "Name" with "Clam Bake"
    And I fill in "Description" with "Let's bake all the clams from the Chesapeake"
    And I upload an image to "Picture"
    And I fill in "Minimum" with "800"
    And I fill in "Maximum" with "1000"
    And I select "Easy" from "Difficulty"
    And I fill in "Tags" with "athletes, Captains"
    And I press "Update"

    Then I should see "Viewing Fundraiser Type"
    And I should see "Clam Bake"
    And I should see "Let's bake all the clams from the Chesapeake"
    And I should see "$800.0 - $1000.0"
    And I should see "athletes, captains"
    And I should see "Fundraiser Type was successfully updated."


  @shouldwork
  Scenario: Citizen Effect Attempts to Add a Fundraiser Type
    Given I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I follow "Fundraiser Types"
    Then I should see "(+) Add Fundraiser Type"
    When I follow "(+) Add Fundraiser Type"
    Then I should see "New Fundraiser Type"
    When I press "Create"
    Then I should see "Name can't be blank"


  @shouldwork
  Scenario: Citizen Effect Manages CP Experiences to a Fundraiser Type
    Given there is a CP with the name "Chuck Norris"
    And there is a CP with the name "Steven Segal"
    And there is a CP with the name "Bruce Lee"
    And there is a fundraiser type named "Bake Sale"
    And there is a fundraiser type experience from "Chuck Norris" for "Bake Sale" with quote "Test Quote"
    And I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I follow "Fundraiser Types"
    Then I should see "Edit"
    When I follow "Edit"
    Then I should see "Editing Fundraiser Type"
    And I should see "Manage Associated CP Experiences"
    When I follow "Manage Associated CP Experiences"
    Then I should see "Listing Citizen Philanthropist Experiences"
    And I should see "<< Back to Fundraiser Type"
    And I should see "Show"
    And I should see "Edit"
    And I should see "Destroy"
    When I click "Show"
    Then I should see "Viewing Citizen Philanthropist Experience"
    And I should see "CP Name"
    And I should see "Chuck Norris"
    And I should see "Quote"
    And I should see "Test Quote"
    When I go back
    And I click "Edit"
    Then I should see "Editing Citizen Philanthropist Experience"
    And I should see "CP Name"
    And I should see "Quote"
    And I should see "Update"
    When I select "Steven Segal" from "CP Name"
    And I fill in "Quote" with "Chuck Norris can do 0-handed pushups. I cannot."
    And I press "Update"
    Then I should see "Viewing Citizen Philanthropist Experience"
    And I should see "Steven Segal"
    And I should see "Chuck Norris can do 0-handed pushups. I cannot."
    And I should see "Back"
    When I follow "Back"
    Then I should see "Listing Citizen Philanthropist Experiences"
    Then I should see "Destroy"
    When I click "Destroy"
    And I confirm
    Then I should see "Citizen Philanthropist Experience Removed"
    And I should see "(+) Add Citizen Philanthropist Experience"
    When I click "(+) Add Citizen Philanthropist Experience"
    Then I should see "New Citizen Philanthropist Experience"
    And I should see "CP Name"
    And I should see "Quote"
    And I should see "Create"
    When I select "Bruce Lee" from "CP Name"
    And I fill in "Quote" with "I only need 1 pinky to do a handstand."
    And I press "Create"
    Then I should see "Viewing Citizen Philanthropist Experience"
    And I should see "Bruce Lee"
    And I should see "I only need 1 pinky to do a handstand."


  @shouldwork
  @unified_upload
  Scenario: Citizen Effect Adds PDFs to a Fundraiser Type
    Given there is a CP with the name "Chuck Norris"
    And there is a fundraiser type named "Bake Sale"
    And there is a pdf "pdf_test.pdf" for "Bake Sale"
    And I am logged in as a "citizen_effect_admin"
    And I am on the dashboard
    When I follow "Fundraiser Types"
    And I follow "Edit"
    Then I should see "Manage Associated PDFs"
    When I follow "Manage Associated PDFs"
    Then I should see "Listing Files"
    And I should see "Show"
    And I should see "Edit"
    And I should see "Destroy"
    When I click "Show"
    Then I should see "Viewing File"
    And I should see "Filename"
    And I should see "pdf_test.pdf"
    When I go back
    And I click "Edit"
    Then I should see "Editing File"
    And I should see "Filename"
    And I should see "Current File"
    And I should see "pdf_test.pdf"
    When I upload a pdf "pdf_test-copy.pdf" to "Filename"
    And I press "Update"
    Then I should see "Viewing File"
    And I should see "Filename"
    And I should see "pdf_test-copy.pdf"
    And I should see "Back"
    When I follow "Back"
    Then I should see "Listing Files"
    Then I should see "Destroy"
    When I click "Destroy"
    And I confirm
    Then I should see "File Removed"
    And I should see "(+) Add File"
    When I click "(+) Add File"
    Then I should see "New File"
    And I should see "Filename"
    And I should see "Create"
    When I upload a pdf "pdf_test.pdf" to "Filename"
    And I press "Create"
    Then I should see "Viewing File"
    And I should see "File was successfully added."
    And I should see "pdf_test.pdf"
