class CommunityMemberProfile < ActiveRecord::Base
  belongs_to                 :project
  has_many                   :messages, :class_name => "CommunityMemberMessage"
  has_many                   :pictures, :class_name => "CommunityMemberPicture"
  has_many                   :videos,   :class_name => "CommunityMemberVideo"
  has_many                   :audios,   :class_name => "CommunityMemberAudio"
  has_one_unified_attachment :profile_picture
  
  named_scope :latest, :order => "updated_at DESC" # STUB, i think this is reasonable
  
  accepts_nested_attributes_for :profile_picture
  
  validates_presence_of :project
  validates_presence_of :name
  
  def picture_url_thumb(size_name = :standard_thumb) # STUB
    self.profile_picture.andand.url(size_name) ||
      UnifiedUpload.new(:flavor => "community_member_profile_picture").url(size_name)
  end
  
  def latest_video
    self.videos.find(:first, :order => "created_at DESC")
  end

end
