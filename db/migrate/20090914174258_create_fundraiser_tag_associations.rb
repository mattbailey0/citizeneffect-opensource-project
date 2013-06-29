class CreateFundraiserTagAssociations < ActiveRecord::Migration
  def self.up
    create_table :fundraiser_tag_associations do |t|
      t.integer  :fundraiser_tag_id
      t.integer  :fundraiser_type_id
      t.timestamps
    end
  end

  def self.down
    drop_table :fundraiser_tag_associations
  end
end
