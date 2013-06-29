class CreateRefunds < ActiveRecord::Migration
  def self.up
    create_table :refunds do |t|
      t.integer :amount_in_cents
      t.integer :project_id
      t.string :comment
      t.integer :donation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :refunds
  end
end
