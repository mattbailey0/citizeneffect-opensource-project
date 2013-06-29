class CreateFundraiserTypeExperiences < ActiveRecord::Migration
  def self.up
    create_table :fundraiser_type_experiences do |t|
      t.integer  :fundraiser_type_id
      t.integer  :user_id
      t.text     :quote
      t.timestamps
    end
  end

  def self.down
    drop_table :fundraiser_type_experiences
  end
end
