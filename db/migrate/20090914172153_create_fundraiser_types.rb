class CreateFundraiserTypes < ActiveRecord::Migration
  def self.up
    create_table :fundraiser_types do |t|
      t.string  :name
      t.text    :description
      t.integer :minimum_typical_amount_raised_in_cents
      t.integer :maximum_typical_amount_raised_in_cents
      t.timestamps
    end
  end

  def self.down
    drop_table :fundraiser_types
  end
end
