class RemoveModifiedProjectAmountInCentsFromDonation < ActiveRecord::Migration
  def self.up
    remove_column :donations, :modified_project_amount_in_cents
  end

  def self.down
    add_column :donations, :modified_project_amount_in_cents, :integer
  end
end
