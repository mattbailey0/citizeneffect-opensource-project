class MailingList < ActiveRecord::Base
  belongs_to :project
  has_many   :subscribers, :class_name => "MailingListUser"
  has_many   :mailing_list_emails
  
  validates_uniqueness_of :project_id
  
  def self.global_list
    self.find(1)
  end
  
  def main_picture_url(size_name)
    self.project ? self.project.main_picture_url(size_name) : 
      UnifiedUpload.new(:flavor => "mailing_list").url(size_name)
  end
  
  def name
    self.project ?
      "#{self.project.name} Mailing List" :
      "Citizen Effect Mailing List"
  end
  
  def summary_for_website
    self.project ?
      self.project.summary_for_website :
      "Global mailing list for news and information about Citizen Effect"
  end
  
  def drafts
    mailing_list_emails.scoped(:conditions => { :draft => true }, :order => "created_at DESC")
  end
  
end
