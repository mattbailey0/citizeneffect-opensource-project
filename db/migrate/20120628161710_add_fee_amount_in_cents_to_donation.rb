class AddFeeAmountInCentsToDonation < ActiveRecord::Migration
  def self.up
    add_column :donations, :fee_amount_in_cents, :integer
  end

  def self.down
    remove_column :donations, :fee_amount_in_cents
  end
end
