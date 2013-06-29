module NavigationHelpers
  # Maps a static name to a static route.
  #
  # This method is *not* designed to map from a dynamic name to a 
  # dynamic route like <tt>post_comments_path(post)</tt>. For dynamic 
  # routes like this you should *not* rely on #path_to, but write 
  # your own step definitions instead. Example:
  #
  #   Given /I am on the comments page for the "(.+)" post/ |name|
  #     post = Post.find_by_name(name)
  #     visit post_comments_path(post)
  #   end
  #
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      home_index_path
    when /the login/
      login_path
    when /the dashboard/
      admin_root_path
    when /the administration index page/
      admin_root_path
    when /the CP list page/
      admin_role_user_role_associations_path(Role.find_by_name("cp"))
    when /the admin projects page/
      admin_projects_path
    when /the projects page/
      projects_path
    when /the CP application page/
      new_cp_application_path
    when /the user list page/
      admin_all_users_path
    when /the needing donations rss feed/
      needing_donations_projects_path(:format => :rss)
    when /the needing a cp rss feed/
      needing_a_cp_projects_path(:format => :rss)
    when /the yoga challenge donation page/
      yoga_donations_path
    when /the bwb donation page/
      tourney_donations_path
      
      
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end
end

World(NavigationHelpers)
