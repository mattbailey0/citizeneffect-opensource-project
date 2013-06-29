class PartnerCampaignAssociation < ActiveRecord::Base
  belongs_to :partner
  belongs_to :campaign
end
