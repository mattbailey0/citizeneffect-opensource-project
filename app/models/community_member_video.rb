class CommunityMemberVideo < ActiveRecord::Base
  include EmbeddedYoutube
  
  belongs_to  :community_member_profile
  belongs_to  :project_report, :polymorphic => true
  
  validates_presence_of :community_member_profile
  validates_presence_of :url
  
  before_save :touch_profile
  
  def touch_profile
    self.community_member_profile.touch if self.community_member_profile
  end
end
