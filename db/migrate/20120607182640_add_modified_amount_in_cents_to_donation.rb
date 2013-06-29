class AddModifiedAmountInCentsToDonation < ActiveRecord::Migration
  def self.up
    add_column :donations, :modified_amount_in_cents, :integer
  end

  def self.down
    remove_column :donations, :modified_amount_in_cents
  end
end
