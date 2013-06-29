Feature: Project's Social Media Links
  In order to more fully showcase the project  
  As a Citizen Philanthropist
  I want to add links to any social network accounts made specifically for the project

  @shouldwork
  Scenario: CP Adds Social Media Links to Project
    Given there is a project
    And that project has a CP named "John Smith"
    And I am logged in as "John Smith"
    When I view that project 
    Then I should see "Edit Social Media Links"
    When I follow "Edit Social Media Links"
    Then I should see "SOCIAL MEDIA LINKS"
    And I fill in "project_twitter_path" with "this_is_a_twitter_url"
    And I fill in "project_facebook_path" with "woowoofacebookurl"
    And I fill in "project_myspace_path" with "bob_on_myspace"
    And I fill in "project_youtube_path" with "some_video_action"
    And I press an image button with name "save_details"
    Then I should see "Social media links successfully updated."
    And I should see an image link with class "icon_facebook"
    And I should see an image link with class "icon_myspace"
    And I should see an image link with class "icon_twitter"
    And I should see an image link with class "icon_youtube"
    Then I follow "Edit Social Media Links" 
    Then I should see "SOCIAL MEDIA LINKS"
    And I should see "this_is_a_twitter_url"
    And I should see "woowoofacebookurl"
    And I should see "bob_on_myspace"
    And I should see "some_video_action"
    And I fill in "project_twitter_path" with ""
    And I fill in "project_facebook_path" with ""
    And I fill in "project_myspace_path" with ""
    And I fill in "project_youtube_path" with ""
    When I press an image button with name "save_details"
    Then I should see "Social media links successfully updated."
    And I should not see an image link with class "icon_facebook"
    And I should not see an image link with class "icon_myspace"
    And I should not see an image link with class "icon_twitter"
    And I should not see an image link with class "icon_youtube"
