class AddFeePercentageToDonation < ActiveRecord::Migration
  def self.up
    add_column :donations, :fee_percentage, :decimal, :precision => 3, :scale => 2
  end

  def self.down
    remove_column :donations, :fee_percentage
  end
end
