class AddNetAmountInCentsToDonation < ActiveRecord::Migration
  def self.up
    add_column :donations, :net_amount_in_cents, :integer
  end

  def self.down
    remove_column :donations, :net_amount_in_cents
  end
end
