When /^I (go to|am on) that (status update|progress report|impact report|final report)\'s media album$/ do |bogus, bogus2|
  @recent_media_album = MediaAlbum.last
  $browser.goto @host + edit_admin_project_media_album_path(@recent_project, @recent_media_album)
  assert_successful_response
end
