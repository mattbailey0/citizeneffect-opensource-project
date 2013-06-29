When /^I view that blog post$/ do
  $browser.goto @host + blog_blog_post_path(@recent_blog_post.blog, @recent_blog_post)
  assert_successful_response
end

Then /^the recent blog post is set to this one$/ do
  @recent_blog_post = BlogPost.last
end

Then /^I should see the title of that blog post$/ do
  Then "I should see \"#{@recent_blog_post.title}\""
end

Then /^I should see the name of the author of that blog post$/ do
  Then "I should see \"#{@recent_blog_post.posted_by.display_name}\""
end

Then /^I should see the excerpt of that blog post$/ do
  iframe = nil
  (0...$browser.frames.length).each do |i|
    if $browser.frames[i].id == "blog_post_#{@recent_blog_post.id}"
      iframe = $browser.frames[i]
      break
    end
  end

  assert_not_nil iframe.contains_text(@recent_blog_post.excerpt)
end

Then /^I should see the content of that blog post$/ do
  iframe = nil
  (0...$browser.frames.length).each do |i|
    if $browser.frames[i].id == "blog_post_#{@recent_blog_post.id}"
      iframe = $browser.frames[i]
      break
    end
  end

  assert_not_nil iframe.contains_text(@recent_blog_post.body)
end

Then /^that blog post has the title "([^\"]*)"$/ do |title|
  @recent_blog_post.update_attributes!(:title => title)
end

And /^that blog post is (unpublished|a draft|incomplete|not complete)$/ do |title|
  @recent_blog_post.update_attributes!(:is_complete => false)
end

Given /^that project has at least "([^\"]*)" Blog (Post|Posts)$/ do |number, y|
  @recent_blog_post = nil
  number.to_i.times do
    @recent_blog_post  = Factory.create(:blog_post, 
                          :blog_id => @recent_project.blog.id,
                          :posted_by_id => @recent_project.cp.id)
    
  end
end

Given /^there (is|are) at least "([^\"]*)" global Blog (Post|Posts)$/ do |x, number, y|
  if @recent_user
    @recent_user.roles << Role.citizen_effect_admin
  else
    @recent_user = Factory.create("citizen_effect_admin")
  end
  
  @recent_blog_post = nil
  number.to_i.times do
    @recent_blog_post  = Factory.create(:blog_post, 
                          :blog_id => Blog.main_blog.id,
                          :posted_by_id => @recent_user.id)
  end
end
