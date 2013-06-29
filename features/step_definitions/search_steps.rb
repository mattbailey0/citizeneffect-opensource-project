When /^I search for "([^\"]*)"$/ do |search_term|
  $browser.text_field(:id, "searchbox").set(search_term)
  When "I press an image button with class \"btn_search\""
end

Then /^I should see that Project in the search results$/ do
  Then "I should see \"#{@recent_project.name}\""
end
