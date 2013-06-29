class CreateNgoAdminAssociations < ActiveRecord::Migration
  def self.up
    create_table :ngo_admin_associations do |t|
      t.integer :user_id
      t.integer :ngo_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ngo_admin_associations
  end
end
