When /^I view that project\'s featured media page$/ do
  $browser.goto @host + project_featured_media_associations_path(@recent_project)
end
