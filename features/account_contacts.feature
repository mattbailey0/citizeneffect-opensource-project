Feature: Account Contacts
  In order to easily email my contacts from around the site
  As an End User
  I want to manage my account contacts
  
  @shouldwork @spider
  Scenario: User Views his Contacts
    Given I am logged in as a "basic_user"
    And the "basic_user" has a contact "foo@bar.example.com"
    And I am on the homepage
    Then I should see "Contacts"
    When I follow "Contacts"
    Then I should see "foo@bar.example.com"
    And I should see an image link with class "import_from_address_book"
    And I should see an image link with class "add_single_contact"
    And I should see an image link with class "remove_contact"
    And I should see "Invite selected to Citizen Effect"
    When I follow an image link with class "import_from_address_book"
    Then I should see "Import New Contact(s) From:"
    When I go back
    And I follow an image link with class "add_single_contact"
    Then I should see an image button with class "add_contact"
    And I should see "NAME:"
    And I should see "E-MAIL:"

  @external @shouldwork
  Scenario: User Imports New Contacts from Email Accounts
    Given I am logged in as a "basic_user"    
    And I am on the homepage
    When I follow "Contacts"
    And I follow an image link with class "import_from_address_book"
    And I choose "contact_service_gmail"
    When I fill in "Username" with "citizeneffect.tester"
    And I fill in "Password" with "cepass0246813579"
    And I press an image button with class "add_contact"
#     Then I should see "Gmail Username"
#     And I should see "Gmail Password"
#     And I press "Import"
    Then I should see "1 Contact(s) Imported."
# Back to Citizen Effect Page
    And I should see "something@example.com"
  
  @shouldwork  
  Scenario: User Adds Individual Contact
    Given I am logged in as a "basic_user"
    And I am on the homepage
    When I follow "Contacts"
    And I follow an image link with class "add_single_contact"
    And I fill in "NAME:" with "Test User"    
    And I fill in "E-MAIL:" with "something@example.com"
    Then I press an image button with class "add_contact"
    Then I should see "Contact Added"
    And I should see "something@example.com"

  @shouldwork @js
  Scenario: User Removes Individual Contact
    Given I am logged in as a "basic_user"
    And the "basic_user" has a contact "foo@bar.example.com"
    And I am on the homepage
    When I follow "Contacts"
    And I follow an image link with class "remove_contact"
    And I confirm
    Then I should see "Contact 'foo@bar.example.com' removed"
  
  @shouldwork @wip
  Scenario: User Invites Individual Contact to Citizen Effect   
    Given there is a user named "test_user"
    And that user has an imported contact
    And that imported contact has the email "foo@bar.example.com"   
    And that imported contact has the name "foobarbash"
    And I am logged in as "test_user"
    And I have the role "basic_user"
    And I am on the homepage
    When I follow "Contacts"
    And I check "foobarbash"
    And I press "Invite selected to Citizen Effect"
    Then "foobarbash" should be checked
    When I press an image button with class "send_invitations"
    Then I should see "1 contact(s) invited to Citizen Effect"
    # see http://drnicwilliams.com/2009/03/26/testing-outbound-emails-with-cucumber/ for help with
    # tests below
    And "foo@bar.example.com" should receive a Imported Contact Email
    And that email should have "You're invited to Citizen Effect" in the subject

    
