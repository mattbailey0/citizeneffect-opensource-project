class RemoveRefundedAmountInCentsFromDonation < ActiveRecord::Migration
  def self.up
    remove_column :donations, :refunded_amount_in_cents
  end

  def self.down
    add_column :donations, :refunded_amount_in_cents, :integer
  end
end
