class CreateApprovals < ActiveRecord::Migration
  def self.up
    create_table :approvals do |t|
      t.string    :whats_missing
      t.timestamp :sent_back_at
      
      t.string    :next_step
      t.date      :due_on
      t.timestamp :approved_at

      t.text :denied_reason
      t.timestamp :denied_at

      t.timestamps
    end
  end

  def self.down
    drop_table :approvals
  end
end
