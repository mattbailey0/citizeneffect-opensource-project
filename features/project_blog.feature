Feature: Project
  In order to regularly provide updates to the world
  As a CP 
  I want to view and manage Blog Posts

  @shouldwork
  Scenario: Navigating a Blog Post From the Project Page
    Given I am not logged in
    And there is a project
    And that project has a CP named "John Smith"
    And that project has at least "1" Blog Post
    When I view that project
    Then I should see "read more"
    When I follow "read more"
    Then I should see the title of that blog post
    And I should see the name of the author of that blog post
    And I should see the content of that blog post
    And I should see "POSTS YOU MIGHT LIKE"
    And I should see "back to blog"
    And I follow "back to blog"
    And I should see "back to project"
    And I follow "back to project"
    And I should see the name of that project

  @no_longer_works_cause_of_disqus
  Scenario: Leaving a Comment on a Blog Post from the Project Page
    Given I am not logged in
    And there is a project
    And that project has a CP named "John Smith"
    And that project has at least "1" Blog Post
    And there is a user named "test user" 
    And that user has the email "test@example.com"
    When I view that project
    Then I should see "read more"
    When I follow "read more"
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
    And there is a project
    And that project has a CP named "John Smith"
    And that project has at least "1" Blog Post
    And that blog post has the title "Wild and Crazy!"
    And I sleep for "1.5" seconds
    And that project has at least "15" Blog Posts
    When I view that project 
    Then I should see "read previous entries"
    And I should not see "Wild and Crazy!"
    When I follow "read previous entries"
    Then I should see "back to project"
    And I should see "older posts"
    And I should not see "Wild and Crazy!"
    When I follow "older posts"
    And I should see "Wild and Crazy!"

  @shouldwork
  Scenario: Blog Post Share Popup Display From the Project Page
    Given I am not logged in
    And there is a project
    And that project has a CP named "John Smith"
    And that project has at least "1" Blog Post
    When I view that blog post
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
  Scenario: Preview and Create a Valid Project Blog Post
    Given there is a user named "John Smith" 
    And there is a project
    And that project has a CP named "John Smith"
    And that project has at least "1" Blog Post
    And I am logged in as "John Smith"
    When I view that project
    Then I should see "Add Blog Post"
    When I follow "Add Blog Post"
    And I fill in "Title" with "Wild And Crazy Blog Post Title"
    And I fill in "Excerpt" with "Wild and Crazy Blog Post Excerpt"
    And I fill in "Content" with "Wild and Crazy Blog Post Content"
    And I press "Preview"
    And the recent blog post is set to this one
    Then I should see "Wild And Crazy Blog Post Title"
    And I should see the excerpt of that blog post
    And I should see the content of that blog post
    Then I should see "edit"
    When I follow "edit"
    And I select "Education" from "POST CATEGORY"    
    When I press an image button with name "save_and_publish"
    Then I should see "New blog post created."
    When I view that project
    Then I should see "Wild And Crazy Blog Post Title"
    And I should see the excerpt of that blog post

  @shouldwork
  Scenario: Preview and Edit a Valid Project Blog Post
    Given there is a user named "John Smith" 
    And there is a project
    And that project has a CP named "John Smith"
    And that project has at least "1" Blog Post
    And that blog post is unpublished
    And I am logged in as "John Smith"
    When I view that project
    Then I should see "see pending posts"
    When I follow "see pending posts"
    Then I should see "edit" within class "blog-post"
    When I follow "edit" within class "blog-post"
    And I fill in "Title" with "Yet Another Wild And Crazy Blog Post Title"
    And I press "Preview"
    Then I should see "Yet Another Wild And Crazy Blog Post Title"
    Then I should see "edit"
    When I follow "edit"
    And I select "Education" from "POST CATEGORY"    
    When I press an image button with name "save_and_publish"
    Then I should see "New blog post created."
    When I view that project
    Then I should see "Yet Another Wild And Crazy Blog Post Title"

