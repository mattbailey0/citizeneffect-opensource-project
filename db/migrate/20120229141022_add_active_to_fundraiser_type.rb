class AddActiveToFundraiserType < ActiveRecord::Migration
  def self.up
    add_column :fundraiser_types, :active, :boolean
  end

  def self.down
    remove_column :fundraiser_types, :active
  end
end

