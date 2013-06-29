class AddUrlToCampaigns < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :url, :string
  end

  def self.down
    remove_column :campaigns, :url
  end
end
