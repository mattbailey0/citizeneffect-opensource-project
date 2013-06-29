class CreateFundraiserTags < ActiveRecord::Migration
  def self.up
    create_table :fundraiser_tags do |t|
      t.string   :name
      t.timestamps
    end
  end

  def self.down
    drop_table :fundraiser_tags
  end
end
