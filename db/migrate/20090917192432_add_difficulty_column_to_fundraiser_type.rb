class AddDifficultyColumnToFundraiserType < ActiveRecord::Migration
  def self.up
    add_column "fundraiser_types", :difficulty, :integer
  end

  def self.down
    remove_column "fundraiser_types", :difficulty
  end
end
