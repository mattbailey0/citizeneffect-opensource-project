module NewsFeedHelpers
  
  def watch_list_news_feed
    NewsItem.for_projects(self.watched_project_ids)
  end
  
  def news_feed_for_cped_projects
    cped_project_ids = self.cped_projects.find(:all, :select => "id").map(&:id)
    NewsItem.for_projects(cped_project_ids)
  end
    
  def news_feed_for_active_projects
    active_projects = self.projects_in_progress.find(:all, :select => "id").map(&:id)
    NewsItem.for_projects(active_projects)
  end
    
end
