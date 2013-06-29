class NewsItemObserver < ActiveRecord::Observer
  observe :project, :donation
  
  def before_save(newsworthy_object)
    NewsItem.create(:newsworthy_object => newsworthy_object) if newsworthy_object.class.to_s == Donation.to_s
  end
  
  def after_save(newsworthy_object)
    NewsItem.create(:newsworthy_object => newsworthy_object) unless newsworthy_object.class.to_s == Donation.to_s
  end
  

end
