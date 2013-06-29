class CreatePartnerCampaignAssociations < ActiveRecord::Migration
  def self.up
    create_table :partner_campaign_associations do |t|
      t.integer :partner_id
      t.integer :campaign_id

      t.timestamps
    end
  end

  def self.down
    drop_table :partner_campaign_associations
  end
end
