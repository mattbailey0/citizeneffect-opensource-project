class NewsItem < ActiveRecord::Base
  include CommonNamedScopes
  
  NEWS_ITEM_TYPES = [
                     PROJECT_STATUS_CHANGE = "project_status_change",
                     NEW_DONATION          = "new_donation"
                    ]

  default_scope :order => "created_at DESC"
  named_scope :for_projects, Proc.new {|*project_ids| {:conditions => {:newsable_type => "Project", :newsable_id => project_ids.flatten }}}
  
  belongs_to :newsable, :polymorphic => true
    
  validates_presence_of :newsable
  validates_presence_of :news_item_type
  validates_presence_of :news_message
  
  alias :ar_newsable= :newsable=
  def newsable=(object)
    raise "No! Bad Developer! Please use newsworthy_object="
  end

  def newsworthy_object=(object)
    @newsworthy_object = object
    self.ar_newsable = self.figure_out_news_item_newsable(object)
    self.update_message_and_news_item_type    
  end
  
  
  def figure_out_news_item_newsable(newsworthy_object)
    case @newsworthy_object.class.to_s
      when Project.to_s   then @newsworthy_object
      when Donation.to_s  then @newsworthy_object.project
    end
  end

  
  def update_message_and_news_item_type
    self.update_news_item_type
    self.update_message
  end
  
  def update_news_item_type
    self.news_item_type = case @newsworthy_object.class.to_s
      when Project.to_s  then PROJECT_STATUS_CHANGE
      when Donation.to_s then NEW_DONATION
    end    
  end
  
  def update_message
    self.news_message = case self.news_item_type
      when PROJECT_STATUS_CHANGE then self.build_project_status_message
      when NEW_DONATION          then self.build_donation_message
    end 
  end
  
  def build_project_status_message
    return nil unless self.newsable.project_status_id_changed?
    return nil unless ProjectStatus.statuses_that_are_user_visible.include?(self.newsable.project_status)
    case self.newsable.project_status_id
      when ProjectStatus.awaiting_cp.id           then "New Project Added"
      when ProjectStatus.construction_complete.id then "#{self.newsable.name} completed!"
      when ProjectStatus.fundraising.id           then "New CP added to #{self.newsable.name}!"
      else nil
    end
  end
  
  def build_donation_message
    if @newsworthy_object.new_record? and !@newsworthy_object.anonymous
      "#{@newsworthy_object.display_name} donated to #{self.newsable.andand.name || 'Citizen Effect'}!"
    else
      nil
    end 
  end
  
  def type_icon_url(size_name = :news_item) 
    case self.news_item_type
      when PROJECT_STATUS_CHANGE then self.newsable.type_icon_url(size_name)
      when NEW_DONATION          then self.newsable.type_icon_url(size_name)
    end 
  end
  
end
