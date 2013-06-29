Feature: User Profile
  In order to share my information with the world
  As an End User
  I want manage my profile

  @shouldwork
  Scenario: Login and add a picture to my profile
    Given I am not logged in
    And there is a user named "test user" 
    And that user has the email "test@example.com"
    And I go to the homepage
    Then I should see "login"
    And I fill in "login" with "test@example.com"
    And I fill in "password" with "password"
    And I press the login button
    Then I should see "Profile"
    When I follow "Profile"
    Then I should see "Edit My Picture"
#    When I follow "Edit My Photo" without refreshing the page # Not sure how to signify AJAX links
    #having this on a popup seems unnecessary
    When I follow "Edit My Picture"
    Then I should see "PICTURE"
    And I should see "SELECT PROFILE PICTURE:"
    When I upload an image to "SELECT PROFILE PICTURE:"
    And I press an image button with class "update_picture"
#    And I press "Create"
    Then I should see "Picture successfully updated."

  @shouldwork
  Scenario: Login and edit me about me text
    Given I am not logged in
    And there is a user named "test user" 
    And that user has the email "test@example.com"
    And I go to the homepage
    Then I should see "login"
    And I fill in "login" with "test@example.com"
    And I fill in "password" with "password"
    And I press the login button
    Then I should see "Profile"
    When I follow "Profile"
    Then I should see "Edit About Me"
    When I follow "Edit About Me"
    Then I should see "ABOUT ME:"
    And I should see "ABOUT ME:"
    When I fill in "ABOUT ME:" with "In France, I'd be called le renard. Hunted, with only my cunning to protect me."
    And I press an image button with class "update_about_me"
    Then I should see "About me successfully updated."
    And I should see "In France, I'd be called le renard. Hunted, with only my cunning to protect me."

  @shouldwork @external
  Scenario: Login and edit my social networks
    Given I am not logged in
    And there is a user named "test user" 
    And that user has the email "test@example.com"
    And I go to the homepage
    Then I should see "login"
    And I fill in "login" with "test@example.com"
    And I fill in "password" with "password"
    And I press the login button
    Then I should see "Profile"
    When I follow "Profile"
    Then I should see "Edit My Social Networks"
    When I follow "Edit My Social Networks"
    Then I should see "SOCIAL MEDIA LINKS"
    When I fill in "linkedin" with "somename"
    And I fill in "twitter" with "somename"
    And I fill in "facebook" with "somename"
    And I fill in "myspace" with "somename"
    And I fill in "youtube" with "CitizenEffectvideo"
    And I fill in "blog" with "http://www.example.com/"
    And I press an image button with class "update_social_media_links"
    Then I should see "Social media links successfully updated."
    And I should see "LinkedIn"
    And I should see "Twitter"
    And I should see "Facebook"
    And I should see "MySpace"
    And I should see "YouTube"
    And I should see "Blog"
    When I follow "Blog"
    Then I should see the page title "Example Web Page"
  
  @shouldwork
  Scenario: Login, Change Name and Password, and Re-Login
    Given I am not logged in
    And there is a basic user with the name "test user" 
    And that user has the email "test@example.com"
    And I go to the homepage
    Then I should see "login"
    And I fill in "login" with "test@example.com"
    And I fill in "password" with "password"
    And I press the login button
    Then I should see "test user"
    When I follow "test user"
    And I fill in "FIRST NAME:" with "Biz"
    And I fill in "LAST NAME:" with "Stone"
# Not necessary
#    And I fill in "Password" with "password"
    And I fill in "NEW PASSWORD:" with "password2"
    And I fill in "CONFIRM NEW PASSWORD:" with "password2"
    And I press an image button with class "update_account_info"
    Then I should see "Account information successfully updated."
    And I should see "Logout"
    When I click "Logout"
    And I go to my profile page
    Then I should see "Biz S."
    When I fill in "login" with "test@example.com"
    And I fill in "password" with "password2"
    And I press the login button
    Then I should see "Profile"
    When I follow "Profile"
    Then I should see "Biz Stone"

  @shouldwork
  Scenario: Uploading your first profile picture
    Given there is a basic user with the name "test user" 
    And I am logged in as "test user"
    And that user has no picture
    When I follow "test user"
    Then I should see "test"
    And I should see "user"

