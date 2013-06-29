class AddPermalinkToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :permalink, :string
  end

  def self.down
    remove_column :campaigns, :permalink
  end
end
