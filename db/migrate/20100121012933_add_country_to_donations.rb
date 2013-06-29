class AddCountryToDonations < ActiveRecord::Migration
  def self.up
    add_column "donations", :country, :string
    Donation.update_all("country = 'United States'")
  end

  def self.down
  end
end
