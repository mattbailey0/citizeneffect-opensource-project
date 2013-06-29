class AddNetActualAmountInCentsToDonation < ActiveRecord::Migration
  def self.up
    add_column :donations, :net_actual_amount_in_cents, :integer
  end

  def self.down
    remove_column :donations, :net_actual_amount_in_cents
  end
end
