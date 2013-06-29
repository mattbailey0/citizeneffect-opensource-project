class PartnerProjectProgressReport < ActiveRecord::Base
  include ApprovalStatusesHelper
  
  belongs_to                   :user
  belongs_to                   :media_album
  has_one                      :approvable_association, :as => :approvable
  has_one                      :approval, :through => :approvable_association
  has_one                      :project_report_association, :as => :project_report
  has_one                      :project, :through => :project_report_association
  has_many_unified_attachments :associated_files
  has_many                     :community_member_profiles, :through => :project
  has_many                     :community_member_videos,   :as => :project_report
  has_many                     :community_member_pictures, :as => :project_report
  has_many                     :community_member_messages, :as => :project_report
  has_many                     :community_member_audios,   :as => :project_report
  
  before_create :new_album_for_update
  validates_presence_of :user_id
  
  def new_album_for_update
    self.media_album = MediaAlbum.create(
                                         :title   => "Progress Report from #{Time.now.strftime('%m/%d/%Y')}",
                                         :project => self.project,
                                         :user    => self.user
                                         )
  end

end
