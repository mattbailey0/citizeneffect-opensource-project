class AddTrackingCodeToDonations < ActiveRecord::Migration
  def self.up
    add_column "donations", :campaign_code, :string
  end

  def self.down
  end
end
