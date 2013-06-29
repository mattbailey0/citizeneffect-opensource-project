class AddFieldPartnerEmailToDonation < ActiveRecord::Migration
  def self.up
    add_column "donations", :field_partner_emails, :boolean, :default => true
    change_column_default "donations", :mailing_list, true
  end

  def self.down
  end
end
