class AddLogoUrlToCampaign < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :logo_url, :string
  end

  def self.down
    remove_column :campaigns, :logo_url
  end
end
