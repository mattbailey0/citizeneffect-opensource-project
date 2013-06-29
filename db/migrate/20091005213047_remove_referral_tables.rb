class RemoveReferralTables < ActiveRecord::Migration
  def self.up
 #    drop_table "referrals"
#     drop_table "cp_application_referral_associations"
    
    add_column "cp_applications", :referrer_id, :integer
    add_column "cp_applications", :referral_source_id, :integer
  end

  def self.down
  end
end
