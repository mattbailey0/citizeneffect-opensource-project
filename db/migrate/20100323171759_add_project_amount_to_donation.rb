class AddProjectAmountToDonation < ActiveRecord::Migration
  def self.up
    add_column :donations, :project_amount_in_cents, :integer, :default => 0, :allow_nil => false
    Donation.reset_column_information
    Donation.all.each do |d|
      next unless d.project
      d.update_attributes(:project_amount_in_cents => d.amount_in_cents)
    end
  end

  def self.down
  end
end
