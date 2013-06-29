Feature: Global Blog
  In order to regularly provide updates to the world
  As a Citizen Effect Admin
  I want to view and manage Blog Posts

  @shouldwork 
  Scenario: Navigating a Blog Post From the Homepage
    Given I am not logged in
    And there is at least "1" global Blog Post
    When I view the homepage
    Then I should see "share | read more"
    When I follow a link with class "blog_read_more"
    Then I should see the title of that blog post
    And I should see the name of the author of that blog post
    And I should see the content of that blog post
    And I should see "POSTS YOU MIGHT LIKE"
    And I should see "back to blog"
    
  @no_longer_works_cause_of_disqus
  Scenario: Leaving a Comment on a Blog Post from the Homepage
    Given I am not logged in
    And there is at least "1" global Blog Post
    And there is a user named "test user" 
    And that user has the email "test@example.com"
    When I view the homepage
    Then I should see "share | read more"
    When I follow a link with class "blog_read_more"
    Then I should see "BLOG COMMENTS (0)"
    And I should see "Log in to make a comment"
    When I follow "Log in to make a comment"
    And I fill in "login_page" with "test@example.com"
    And I fill in "password_page" with "password"
    And I press an image button with class "login_button"
    Then I should see "BLOG COMMENTS (0)"
    Then I should see "POST A COMMENT"
    When I fill in "blog_comment_comment" with "This is a wild and crazy comment!"
    And I press "Submit comment"
    Then I should see "BLOG COMMENT (1)"
    And I should see "test u."
    And I should see "This is a wild and crazy comment!"

  @shouldwork
  Scenario: Navigating Older Posts
    Given I am not logged in
    And there is at least "1" global Blog Post
    And that blog post has the title "Wild and Crazy!"
    And I sleep for "1.5" seconds
    And there are at least "15" global Blog Posts
    When I view the homepage
    And I should not see "Wild and Crazy!"
    Then I should see "view more blog posts"
    When I follow "view more blog posts"
    And I should see "older posts"
    And I should not see "Wild and Crazy!"
    When I follow "older posts"
    And I should see "Wild and Crazy!"

  @shouldwork
  Scenario: Blog Post Share Popup Display From the Homepage
    Given I am not logged in
    And there is at least "1" global Blog Post
    When I view the homepage
    Then I should see "share"
    When I click "share"
    Then I should see "Share on MySpace"
    And I should see "Share on Facebook"
    And I should see "Retweet"
    And I should see "FriendFeed"
    And I should see "Reddit"
    And I should see "Digg"
    And I should see "StumbleUpon"
    And I should see "Delicious"
    And I should see "LinkedIn"

  @shouldwork
  Scenario: Create a Valid Global Blog Post
    Given I am logged in as a "citizen_effect_admin"
    When I visit the administration index page
    Then I should see "Website Pages"
    When I follow "Website Pages"
    Then I should see "Blog"
    When I follow "Blog"
    Then I should see "(+) Add Blog Post"
    When I follow "(+) Add Blog Post"
    And I fill in "blog_post_title" with "Wild And Crazy Blog Post Title"
    And I fill in "EXCERPT:" with "Wild and Crazy Blog Post Excerpt"
    And I fill in "CONTENT:" with "Wild and Crazy Blog Post Content"
    And I select "Education" from "POST CATEGORY"
#    And I check "Publish?"
    And I press an image button with name "save_and_publish"
    Then I should see "New blog post created."
    And the recent blog post is set to this one
    When I visit the homepage
    Then I should see "Wild And Crazy Blog Post Title"
    And I should see the excerpt of that blog post

  @shouldwork
  Scenario: Edit a Global Blog Post
    Given I am logged in as a "citizen_effect_admin"
    And there is at least "1" global Blog Post
    When I visit the administration index page
    Then I should see "Website Pages"
    When I follow "Website Pages"
    Then I should see "Blog"
    When I follow "Blog"
    Then I should see "edit"
    When I follow "edit" 
    And I fill in "TITLE:" with "Yet Another Wild And Crazy Blog Post Title"
    And I press an image button with name "save_and_publish"
    Then I should see "New blog post created."
    When I visit the homepage
    Then I should see "Yet Another Wild And Crazy Blog Post Title"

  @shouldwork
  Scenario: Blog feed items contain guid
    Given there is at least "1" global Blog Post
    When I view the homepage
    And I click an image link with class "rss_link_picture"
    Then the feed should conatin the guid for that blog post
