Feature: Project's CP Message
  In order to more fully share who I am  
  As a Citizen Philanthropist
  I want to add a special message to my project

  @2  
  Scenario: CP Adds CP Message to Project, logs out, and still sees message
    Given there is a user named "John Smith" 
    And I am logged in as "John Smith"
    And there is a project
    And that project has a CP named "John Smith"
    When I view that project
    Then I should see "Edit CP Message"
    When I follow "Edit CP Message"
    Then I should see "CP Message"
    And I fill in "message" with "I'm Fred and this is a great project.  Show me the money and save some lives!"
    And I press "Save Message"
    Then I should see "CP Message successfully updated"
    And I should see "I'm Fred and this is a great project.  Show me the money and save some lives!"
    When I follow "logout"
    And I view that project
    Then I should see "I'm Fred and this is a great project.  Show me the money and save some lives!"
