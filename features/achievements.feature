Feature: Account Achievements
  In order to reward users for raising money and CPing projects
  As an End User
  I want to recieve and view Achievements
  
  @shouldwork
  Scenario: End User Donates and receives donation achievement
    Given there is a project
    And that project is user visible
    And that project has a CP
    And there is a user named "Jane Doe"
    And that user has donated "98" dollars
    And that user has the address "Some address"
    And I am logged in as "Jane Doe"
    When I view that project
    Then I should see an image link with class "donate_to_project"
    When I follow an image link with class "donate_to_project"
    Then I should see "DONATE TO"
    And I should see the name of that project in all caps
    And I should see "401 Mission Street"
    And I select "0%" from "TIP"
    When I fill in the credit card information
    And I select "$100.00" from "DONATION AMOUNT"
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Jane for your generous contribution!"
    And I should see "You've donated $100"
    And achievement calculations run
    And I follow "Profile"
    Then I should see "Total Donated: $198"
    And I should see "HONORABLE DONATION"
    And I should see "Has donated over $100"
  
  @shouldwork
  Scenario: End User Donates and receives lives impacted achievement
    Given there is a project
    And that project is user visible
    And that project has a CP
    And that project has primary lives impacted set to "100"
    And that project has secondary lives impacted set to "1000"  
    And there is a user named "Jane Doe"
    And that user has impacted "10" lives as a donor
    And that user has the address "Some address"
    And I am logged in as "Jane Doe"
    When I view that project
    Then I should see an image link with class "donate_to_project"
    When I follow an image link with class "donate_to_project"
    Then I should see "DONATE TO"
    And I should see the name of that project in all caps
    And I should see "401 Mission Street"
    And I select "0%" from "TIP"
    When I fill in the credit card information
    And I select "$100.00" from "DONATION AMOUNT"
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Jane for your generous contribution!"
    And I should see "You've donated $100"
    And achievement calculations run
    And I follow "Profile"
    Then I should see "Lives Impacted: 1,110"
    And I should see "100 LIVES IMPACTED"
    And I should see "Has successfully impacted"
    And I should see "100 lives, through donations"
  
  @shouldwork
  Scenario: End User Donates and receives projects donated
    Given there is a project
    And that project is user visible
    And that project has a CP    
    And there is a user named "Jane Doe"
    And that user has donated to "4some address" projects
    And that user has the address "401 Mission Street"
    And I am logged in as "Jane Doe"
    When I view that project
    Then I should see an image link with class "donate_to_project"
    When I follow an image link with class "donate_to_project"
    Then I should see "DONATE TO"
    And I should see the name of that project in all caps
    And I should see "401 Mission Street"
    And I select "0%" from "TIP"
    When I fill in the credit card information
    And I select "$100.00" from "DONATION AMOUNT"
    And I check "I agree to the Terms of Service"
    And I press an image button with class "confirm_donate"
    Then I should see "Thank you, Jane for your generous contribution!"
    And I should see "You've donated $100"
    And achievement calculations run
    And I follow "Profile"
    Then I should see "# Projects Donated: 5"
    And I should see "GIVING BACK"
    And I should see "Has successfully donated"
    And I should see "to 5 Citizen Effect projects"

  @shouldwork
  Scenario: CP Completes project and receives projects completed
    Given there is a project
    And that project has a CP named "John Smith"
    And that user has completed "4" projects
    And that project has just recieved its final donation
    And achievement calculations run
    And I am logged in as "John Smith"
#NotAFeature
#     And I received an email # http://drnicwilliams.com/2009/03/26/testing-outbound-emails-with-cucumber/
#     When I open the email
#     Then I should see "You've received a new Citizen Effect Achievement" in the subject
#     When I click the first link in the email
# "CP" profile tab/page
    And I follow "Profile"
    And I follow a link with id "projects"
    Then I should see "# Projects Completed: 5"
    And I should see "5 PROJECTS COMPLETED"
    And I should see "Has successfully completed"
    And I should see "5 projects"    
  
  @shouldwork
  Scenario: CP Completes project and receives $ raised achievement
    Given there is a project
    And that project has a CP named "John Smith"
    And that user has raised "9000" dollars
    And that project has a total donation amount of "5000" dollars
    And that project has just recieved its final donation
    And achievement calculations run
    And I am logged in as "John Smith"
#NotAFeature
#     And I received an email # http://drnicwilliams.com/2009/03/26/testing-outbound-emails-with-cucumber/
#     When I open the email
#     Then I should see "You've received a new Citizen Effect Achievement" in the subject
#     When I click the first link in the email
    And I follow "Profile"
    And I follow a link with id "projects"
    Then I should see "$10,000.00 RAISED"
    And I should see "Has raised"
    And I should see "$10,000.00 for projects"
    And I should see "Total Raised: $14,000"

  @shouldwork
  Scenario: CP Completes project and receives lives impacted achievement
    Given there is a project
    And that project has a CP named "John Smith"
    And that user has impacted "10" lives as a CP
    And that project has primary lives impacted set to "100"  
    And that project has secondary lives impacted set to "1000"  
    And that project has just recieved its final donation
    And achievement calculations run
    And I am logged in as "John Smith"
#NotAFeature
#     And I received an email # http://drnicwilliams.com/2009/03/26/testing-outbound-emails-with-cucumber/
#     When I open the email
#     Then I should see "You've received a new Citizen Effect Achievement" in the subject
#     When I click the first link in the email
# "CP" profile tab/page
    And I follow "Profile"
    And I follow a link with id "projects"
    Then I should see "100 LIVES IMPACTED"
    And I should see "Has successfully impacted"
    And I should see "100 lives, as a CP"
    And I should see "Lives Impacted (as a CP): 1,100"
