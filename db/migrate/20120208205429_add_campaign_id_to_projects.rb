class AddCampaignIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :campaign_id, :int
  end

  def self.down
    remove_column :projects, :campaign_id
  end
end
