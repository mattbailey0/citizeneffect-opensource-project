class CreateProjectCampaignAssociations < ActiveRecord::Migration
  def self.up
    create_table :project_campaign_associations do |t|
      t.integer :project_id
      t.integer :campaign_id

      t.timestamps
    end
  end

  def self.down
    drop_table :project_campaign_associations
  end
end
