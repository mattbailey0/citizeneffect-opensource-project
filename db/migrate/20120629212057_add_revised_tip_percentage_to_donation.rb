class AddRevisedTipPercentageToDonation < ActiveRecord::Migration
  def self.up
    add_column :donations, :revised_tip_percentage, :integer
  end

  def self.down
    remove_column :donations, :revised_tip_percentage
  end
end
