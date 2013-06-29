class PartnerProjectStatusUpdate < ActiveRecord::Base
  include CommonNamedScopes

  belongs_to                   :user
  belongs_to                   :media_album
  has_many_unified_attachments :associated_files
  has_one                      :project_report_association, :as => :project_report
  has_one                      :project, :through => :project_report_association
  has_many                     :community_member_profiles, :through => :project
  has_many                     :community_member_videos,   :as => :project_report
  has_many                     :community_member_pictures, :as => :project_report
  has_many                     :community_member_messages, :as => :project_report
  has_many                     :community_member_audios,   :as => :project_report
  
  validates_presence_of :title
  # May Yu from CE requested that this not be required, so they can just upload a file
  # validates_presence_of :field_updates 
  validates_presence_of :user_id
    
  before_create :new_album_for_update
  
  def new_album_for_update
    self.media_album = MediaAlbum.create(
                                         :title   => "Status Update #{self.title}",
                                         :project => self.project,
                                         :user    => self.user
                                        )
  end

  def name #for use in unified uploads; might pull out later if it becomes a hassle
    self.title
  end
end
