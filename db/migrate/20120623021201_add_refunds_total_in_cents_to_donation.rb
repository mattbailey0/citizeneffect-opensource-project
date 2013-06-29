class AddRefundsTotalInCentsToDonation < ActiveRecord::Migration
  def self.up
    add_column :donations, :refunds_total_in_cents, :integer
  end

  def self.down
    remove_column :donations, :refunds_total_in_cents
  end
end
