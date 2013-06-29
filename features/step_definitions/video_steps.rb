Then /^I should see the name of that video$/ do
  Then "I should see \"#{@recent_video.name}\""
end

Then /^I should not see the name of that video$/ do
  Then "I should not see \"#{@recent_video.name}\""
end
