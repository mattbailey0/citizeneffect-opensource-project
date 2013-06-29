Feature: Account Messaging
  In order to communicate with other users without sharing email addresses
  As an End User
  I want to message other users
  
  @shouldfail @2
  Scenario: Logged out user sends message to a CP
    Given I am not logged in
    And there is a user named "test user" 
    And that user has the email "test@example.com"
    And there is a user named "John Smith"
    And there is a project
    And that project has a CP named "John Smith"
    When I view that project
    Then I should see an image link with class "send_a_message"
    When I follow an image link with class "send_a_message"
    Then I should see "Log In"
    And I fill in "login" with "test@example.com"
    And I fill in "password" with "password"
    And I press "Log in"
    # should fail here
    Then I should see "NEW MESSAGE"
    When I fill in "SUBJECT" with "Hello Sir!"
    And I fill in "MESSAGE" with "This is a wild and crazy message!"
    And I press an image button with class "send_message"
    Then I should see "Message successfully sent"
    And I should see "John S."
    And I should see "Hello Sir!"
    And I should see "This is a wild and crazy message!"
# notafeature
#     And "John Smith" should receive an email # http://drnicwilliams.com/2009/03/26/testing-outbound-emails-with-cucumber/
#     And that email should have "You have a new message on Citizen Effect" in the subject

  @shouldwork
  Scenario: Logged in User sends message to another user
    Given there is a user named "test user" 
    And that user has the email "test@example.com"
    And I am logged in as "test user"
    And there is a user named "John Smith"
    And there is a project
    And that project has a CP named "John Smith"
    When I view that project
    Then I should see an image link with class "send_a_message"
    When I follow an image link with class "send_a_message"
    Then I should see "NEW MESSAGE"
    And I should see "John S."
    When I fill in "SUBJECT" with "Hello Again Sir!"
    And I fill in "MESSAGE" with "This is a wild and crazy message!"
    And I press an image button with class "send_message"
    Then I should see "Message successfully sent to John S."
# Yeah, we don't want to see the message we just sent
#     And I should see "John S."
#     And I should see "Hello Again Sir!"
#     And I should see "This is a wild and crazy message!"
# notafeature
#     And "John Smith" should receive an email # http://drnicwilliams.com/2009/03/26/testing-outbound-emails-with-cucumber/
#     And that email should have "You have a new message on Citizen Effect" in the subject

  @shouldwork
  Scenario: User replies to a message  
    Given there is a user named "John Smith" 
    And that user has at least one message 
    And that message is from "test user"
    And that message has the subject "Greetings Johnny"
    And that message has the contents "Hello Johnny!"
    And I am logged in as "John Smith"
    When I view the homepage
    Then I should see "Inbox (1)"
    When I follow "Inbox (1)"
    Then I should see "Greetings Johnny"
    When I follow "Greetings Johnny"
    And I should see "Hello Johnny!"
    And I should see "Reply"
    When I follow "Reply"
    Then I should see "Hello Johnny!"
    And I fill in "MESSAGE" with "This is a wild and crazy reply!"
    And I press an image button with class "send_message"
    Then I should see "Message successfully sent to test u."
# notafeature
#     And "test user" should receive an email # http://drnicwilliams.com/2009/03/26/testing-outbound-emails-with-cucumber/
#     And that email should have "You have a new message on Citizen Effect" in the subject
