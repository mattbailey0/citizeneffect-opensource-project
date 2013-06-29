Feature: CP Application
  In order to become a Citizen Philanthropist
  As an End User
  I want apply and be approved to be a Citizen Philanthropist

  @shouldwork
  Scenario: Apply to be a CP From the Homepage as a logged in user
    Given I am logged in as "Jane Doe"
    And "Jane Doe" has the role "basic_user"
#    And there is a user named "John Smith"
    When I go to the homepage
    Then I should see "be a CP"
    When I follow "be a CP"
    Then I should see "CP APPLICATION"
    And I fill in "Address" with "123 Main Street"
    And I fill in "Address (Line 2)" with ""
    And I fill in "cp_application_city_name" with "New York"
    And I fill in "State" with "NY"
    And I fill in "Zip Code" with "10036"
    And I fill in "Phone Number" with "(888) 123-2345"
    And I fill in "Comment" with "I love this idea!"
    And I check "Food/Security"
    And I check "$500 - $1,000"
    And I check "I agree"
# STUB
#     And I fill in "Referred by" with "John"
#     Then I should see "John Smith" in the search results
#     When I follow "John Smith" without refreshing the page # Not sure how to signify AJAX links
    And I press an image button with class "submit_application"
    Then I should see "Your CP Application has been submitted"
    And I should receive a CP Application submitted email
    And "" should receive a New CP Application email
         
  @shouldwork
  Scenario: Apply to be a CP from the Project Page as a logged in user
    Given I am logged in as "Jane Doe"
    And "Jane Doe" has the role "basic_user"
 #   And there is a user named "John Smith"
    And there is a project with name "Wild And Crazy Well Project in Village"
    And that project is user visible
    When I view that project
    Then I should see an image link with class "become_the_cp_project"
    When I follow an image link with class "become_the_cp_project"
    Then I should see "Wild And Crazy Well Project in Village"
    And I fill in "Address" with "123 University Street"
    And I fill in "Address (Line 2)" with ""
    And I fill in "City" with "Los Angeles"
    And I fill in "State" with "CA"
    And I fill in "Zip Code" with "90012"
    And I fill in "Phone Number" with "(866) 321-0987"
    And I fill in "Comment" with "I can't wait!"
    And I check "India"
    And I check "Clean Energy"
    And I check "I agree"
# STUB
#     And I fill in "Referred by" with "John"
#     Then I should see "John Smith" in the search results
#     When I follow "John Smith" without refreshing the page # Not sure how to signify AJAX links
    And I press an image button with class "submit_application"
    Then I should see "Your CP Application has been submitted"
    And I should receive a CP Application submitted email
    And "" should receive a New CP Application email
    And there is a user named "Admin Guy"
    And that user has the email "admin@example.org"
    And I have the role "citizen_effect_admin"
    And I am logged out
    And I should see "You have been logged out."
    And I am logged in as "Admin Guy"
    And I am on the dashboard
    Then I should see "CP Applications"
    When I follow "CP Applications"
    Then I should see "Show/Approve/Deny"
    When I follow "Show/Approve/Deny"
    And I fill in "Notes" with "Go get 'em!"
    And I press "Approve Now"
    Then I should see "Approval sent."
    When I follow "CPs"
    Then I should see "Jane"
    And I should see "Doe"
    #And "Jane Doe" should receive a CP Application approved email
    And I am logged out
    And I am logged in as "Jane Doe"
    When I view that project
    Then I should see "MEET THE CP"
    And I should see "Jane Doe"
    And I should see "Send Message to Email List"
    And I should see "Edit Social Media Links"
    And I should see "Add Fundraiser"
    And I should see "(+) Add Blog Post"
    And I should see "see pending posts"
#     And I should see "Input Offline Donations"
    And I should see an image link with class "cp_fundraising_tools"
    And I should see "Active Projects"
    And I follow "Profile"
    And I follow a link with id "projects"
    And I should see the name of that project
    

    
#     And I should receive an email # http://drnicwilliams.com/2009/03/26/testing-outbound-emails-with-cucumber/
#     When I open the email
#     Then I should see "We have received your CP Application" in the subject

  @shouldwork
  Scenario: Apply to be a CP From the Homepage as an anonymous user
    Given I am logged out
#    And there is a user named "John Smith"
    When I go to the homepage
    Then I should see "be a CP"
    When I follow "be a CP"
    Then I should see "In order to apply to be a citizen philanthropist, please create an account."
    And I fill in "FIRST NAME" with "Biz"
    And I fill in "LAST NAME" with "Stone"
    And I fill in "E-MAIL" with ""
    And I fill in "ZIPCODE" with "94101"
    And I fill in "PASSWORD" with "password"
    And I fill in "CONFIRM PASSWORD" with "password"
    And I press an image button with class "create_account"
    Then I should see "Thanks for signing up! We're sending you an email with your activation code."
    And I should receive a User Signup Notification email
    When I go to the activation page
    Then I should see "Signup complete!"
    Then I should see "CP APPLICATION"
    And I should see "94101"
    And I fill in "Address" with "1 Market Street"
    And I fill in "Address (Line 2)" with "Suite 1"
    And I fill in "City" with "San Francisco"
    And I fill in "State" with "CA"
    And I fill in "Phone Number" with "(888) 123-2345"
    And I fill in "Comment" with "I give money!"
    And I check "Food/Security"
    And I check "$500 - $1,000"
    And I check "I agree"
# STUB
#     And I fill in "Referred by" with "John"
#     Then I should see "John Smith" in the search results
#     When I follow "John Smith" without refreshing the page # Not sure how to signify AJAX links
    And I press an image button with class "submit_application"
    Then I should see "Your CP Application has been submitted"
    And I should receive a CP Application submitted email
    And "" should receive a New CP Application email

   @shouldwork
   Scenario: Apply to be a CP from the Project Page as an anonymous user
     Given I am logged out
     And there is a project named "Wild And Crazy Well Project in Village"
     And that project is user visible
     When I view that project
     Then I should see an image link with class "become_the_cp_project"
     When I follow an image link with class "become_the_cp_project"
     Then I should see "In order to apply to be a citizen philanthropist, please create an account."
     And I fill in "FIRST NAME" with "Biz"
     And I fill in "LAST NAME" with "Stone"
     And I fill in "E-MAIL" with ""
     And I fill in "ZIPCODE" with "94101"
     And I fill in "PASSWORD" with "password"
     And I fill in "CONFIRM PASSWORD" with "password"
     And I press an image button with class "create_account"
     Then I should see "Thanks for signing up! We're sending you an email with your activation code."
     And I should receive a User Signup Notification email
     When I go to the activation page
     Then I should see "Signup complete!"
     Then I should see "CP APPLICATION"
     Then I should see "Wild And Crazy Well Project in Village"
     And I should see "94101"
     And I fill in "Address" with "123 University Street"
     And I fill in "Address (Line 2)" with ""
     And I fill in "City" with "Los Angeles"
     And I fill in "State" with "CA"
     And I fill in "Phone Number" with "(866) 321-0987"
     And I fill in "Comment" with "I can't wait!"
     And I check "India"
     And I check "Clean Energy"
     And I check "I agree"
     And I press an image button with class "submit_application"
     Then I should see "Your CP Application has been submitted"
     And I should receive a CP Application submitted email
     And "" should receive a New CP Application email


#   Scenario: Apply to be a CP From the Project as a previously-approved CP who doesn't need to fill out info again
#     Given I am logged in as "John Smith"
#     And I have the role "CP"
# #    And there is a user named "John Smith" who has been granted CP Status
#     And there is a project with name "Wild And Crazy Well Project in Village"
#     And that project is user visible
#     When I view that project
#     Then I should see an image link with class "become_the_cp_project"
#     When I follow an image link with class "become_the_cp_project"
#     Then I should see "Wild And Crazy Well Project in Village"
#     And I press "Apply to be a CP"
#     Then I should see "Applied To Be CP"
#     And I should receive an email # http://drnicwilliams.com/2009/03/26/testing-outbound-emails-with-cucumber/
#     When I open the email
#     Then I should see "We have received your CP Application" in the subject
