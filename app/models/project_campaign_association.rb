class ProjectCampaignAssociation < ActiveRecord::Base
  belongs_to :project
  belongs_to :campaign

  validates_uniqueness_of :project_id, :scope => [:campaign_id]
end
