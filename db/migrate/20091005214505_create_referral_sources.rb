class CreateReferralSources < ActiveRecord::Migration
  def self.up
    create_table :referral_sources do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :referral_sources
  end
end
