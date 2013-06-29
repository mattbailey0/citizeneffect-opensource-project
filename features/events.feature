Feature: Project's Events
  In order to hold fundraisers for projects 
  As a Citizen Philanthropist
  I want to manage events

  @shouldwork
  Scenario: CP Adds Event and sees it on the project page, and the projects index page
    Given there is a project
    And that project has a CP named "John Smith"
    And that user has the zip code "10028"
    And I am logged in as "John Smith"
#    And there is a user with the email "" and name "Test User"
    When I view that project
    Then I should see "Add Fundraiser"
    When I follow "Add Fundraiser"
    And I fill in "project_event_name" with "Wild and Crazy Fundraiser Event"
    And I fill in "Host" with "John and Jane"
    And I choose "BAKE SALE"
# from "Fundraiser Type"
    And I fill in "project_event_short_description" with "An event description"
#     And I fill in the selected datetime for "Event Start Time" with "2020-02-02 16:15"
#     And I fill in the selected datetime for "Event End Time" with "2020-02-02 20:15"
    And I fill in "datetimeStart" with "2015-02-02 16:15"
    And I fill in "datetimeEnd" with "2015-02-02 20:15"
    And I fill in "project_event_address1" with "123 Main Street"
    And I fill in "project_event_address2" with ""
    And I fill in "project_event_city" with "New York"
    And I fill in "project_event_state" with "NY"
    And I fill in "project_event_zip" with "10036"
    And I fill in "project_event_country" with "USA"
    And I press an image button with class "add_update_event"
    Then I should see "Fundraiser Created."
    Then I should see an image link with class "invite_more_guests"
    When I follow an image link with class "invite_more_guests"
# This doesn't make sense - JM
#     And I should see "Email Contacts"
# Not sure how to signify AJAX links
#     When I follow "Email Contacts" without refreshing the page 
    Then I should see an image button with class "send_invitations"
    When I fill in "TO:" with ""
    And I fill in "SUBJECT:" with "This is a wild and crazy fundraiser!"
    And I fill in "MESSAGE:" with "Please come to my wild and crazy fundraiser"
    And I press an image button with class "send_invitations"
    Then I should see "1 person invited to 'Wild and Crazy Fundraiser Event'."
    And I should see the name of that project
    And I should see "Wild and Crazy Fundraiser Event"
    And I should see "Feb"
    And I should see "2"
    And I should see "8:15PM"
    And I should see "edit event"
    # When I follow "Wild and Crazy Fundraiser Event" (TODO Phase 3)
    And I should see "Projects"
    When I go to the projects page
    Then I should see "EVENTS NEAR NY"
    And I should see "WILD AND CRAZY FUNDRAISER EVENT"
    And I should see the name of that project
    And I should see "Feb"
    And I should see "2"
    And I should see "4:15PM"

  @shouldwork
  Scenario: CP Edits Event
    Given there is a project
    And that project has a CP named "John Smith"
    And that user has the zip code "10028"
    And I am logged in as "John Smith"
    And that project has an event
    When I view that project
    Then I should see "edit fundraiser"
    When I follow "edit fundraiser"
    And I fill in "project_event_name" with "Updated Wild and Crazy Fundraiser Event"
    And I press an image button with class "add_update_event"
    Then I should see "Fundraiser Updated"
    And I should see "Updated Wild and Crazy Fundraiser Event"

  @shouldwork
  Scenario: CP Removes Event
    Given there is a project
    And that project has a CP named "John Smith"
    And that user has the zip code "10028"
    And I am logged in as "John Smith"
    And that project has an event
    When I view that project
    Then I should see "edit fundraiser"
    When I follow "edit fundraiser"
    Then I should see "Delete Event"
    When I click "Delete Event"
    Then I should see "Fundraiser Removed"
    And I should not see the name of that event

  @shouldwork
  Scenario: CP Invites (More) Users to Existing Event  
    Given there is a project
    And that project has a CP named "John Smith"
    And that user has the zip code "10028"
    And that user has an imported contact 
    And that imported contact has the email ""
    And that project has an event
    And that event is named "Clam Bake"
    And I am logged in as "John Smith"
    When I view that project
    Then I should see "CLAM BAKE"
    When I follow "CLAM BAKE"
    Then I should see an image link with class "invite_more_guests"
    When I follow an image link with class "invite_more_guests"
    Then I should see an image button with class "send_invitations"
    And I should see "Select Contacts"
# Not sure how to signify AJAX links
    When I press "Select Contacts"
    Then I should see "SELECT CONTACTS FROM YOUR IMPORTATED EMAIL LIST"
# Not sure how to signify AJAX links
#    When I click "Import Email Contacts"
    Then I should see ""
    And I check "" 
    And I fill in "SUBJECT:" with "This is a wild and crazy fundraiser!"
    And I fill in "MESSAGE:" with "Please come to my wild and crazy fundraiser"
    And I press an image button with class "send_invitations"
    Then I should see "1 person invited to 'Clam Bake'."
    And delayed job runs
    And "" should receive a Project Event Invitation email
    And that email should have the subject "This is a wild and crazy fundraiser!"

  @shouldwork
  Scenario: Anonymous user RSVPs to Event
    Given there is a project
    And that project has a CP named "John Smith"
    And that user has the zip code "10028"
    And that user has an imported contact 
    And that imported contact has the email ""
    And that project has an event
    And that event is named "Clam Bake"
    And I am logged in as "John Smith"
    When I view that project
    Then I should see "CLAM BAKE"
    When I follow "CLAM BAKE"
    Then I should see an image link with class "invite_more_guests"
    When I follow an image link with class "invite_more_guests"
    Then I should see an image button with class "send_invitations"
    And I should see "Select Contacts"
# Not sure how to signify AJAX links
    When I press "Select Contacts"
    Then I should see "SELECT CONTACTS FROM YOUR IMPORTATED EMAIL LIST"
# Not sure how to signify AJAX links
#    When I click "Import Email Contacts"
    Then I should see ""
    And I check "" 
    And I fill in "SUBJECT:" with "This is a wild and crazy fundraiser!"
    And I fill in "MESSAGE:" with "Please come to my wild and crazy fundraiser"
    And I press an image button with class "send_invitations"
    Then I should see "1 person invited to 'Clam Bake'."
    Given I am not logged in
    And delayed job runs
    And "" should receive a Project Event Invitation email
    And that email should have the subject "This is a wild and crazy fundraiser!"
    When I click the link in the email with "Click here to read event details, location and RSVP!" as the title
    And I should see "Clam Bake"
    Then I should see "YOUR RSVP"
    And I choose "Attending"
    When I press "Submit"
    Then I should see "RSVP Saved."
    And I should see "Clam Bake"
    And I should not see "YOUR RSVP"

  # Scenario: Email reminders sent to event RSVPers 48 hours before event ## TODO is this the right place for this test? Or is it a functional test?
    
