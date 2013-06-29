class CreateApprovableAssociations < ActiveRecord::Migration
  def self.up
    create_table :approvable_associations do |t|
      t.integer :approvable_id
      t.string  :approvable_type
      t.integer :approval_id

      t.timestamps
    end
  end

  def self.down
    drop_table :approvable_associations
  end
end
