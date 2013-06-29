Feature: Offline Donations
  In order to account for donations that were not donated online (e.g. at a fundraising event)
  As an Admin
  I want input the donations I've recieved in person and have sent to Citizen Effect

  @shouldwork
  Scenario: Admin Adds Offline Donation
    Given there is a project
    And that project has a CP named "John Smith"  
    And that project has one regular donation
    And that donation is for the amount of "100.00" dollars
    And I am logged in as a "citizen_effect_admin"
    When I view that project
    Then I should see "Input Offline Donations"
    When I follow "Input Offline Donations"
    When I follow an image link with class "add_offline_donation"
    And I fill in "Amount" with "95.50"
    And I fill in "Donated at" with "2009-10-17 23:35:37"
    And I fill in "First Name" with "Scrooge"
    And I fill in "Last Name" with "Fitzmorris"
    And I fill in "Email" with "scrooge@example.com"
    And I fill in "Address" with "401 Mission Street"
    And I fill in "City" with "Indianapolis"
    And I fill in "State/Province/Region*" with "CA"
    And I select "United States" from "Country*"
    And I fill in "Zip" with "46268"
    And I fill in "Phone Number" with "123-234-5678"
    And I press an image button with class "offline_save"
    Then I should see "Offline donation was successfully created."
    And I should see "$95.50"
    And the CP for that project should receive a donation made email

  @shouldwork
  Scenario: Admin Edits Offline Donation
    Given there is a project
    And that project has a CP named "John Smith"    
    And that project has one regular donation
    And that donation is for the amount of "85.00" dollars
    And that project has one offline donation 
    And that donation is for the amount of "15.00" dollars
    And I am logged in as a "citizen_effect_admin"
    When I view that project
    Then I should see "Input Offline Donations"
    When I follow "Input Offline Donations"
    And I should see "$15.00"
    Then I should see "Edit"
    When I follow "Edit"
    And I fill in "Amount" with "12.00"
    And I press an image button with class "offline_save"
    Then I should see "Offline donation was successfully updated."
    And I should see "$12.00"

  @shouldwork
  Scenario: Admin Removes Offline Donation
    Given there is a project
    And that project has a CP named "John Smith"    
    And that project has one offline donation 
    And that donation is for the amount of "15.00" dollars
    And that project has one regular donation
    And that donation is for the amount of "85.00" dollars
    And I am logged in as a "citizen_effect_admin"
    When I view that project
    Then I should see "Input Offline Donations"
    When I follow "Input Offline Donations"
    And I should see "$15.00"
    When I follow an image link with class "delete_offline_donation"
    Then I should see "Offline donation was successfully deleted."
    And I should see "$0.00"
