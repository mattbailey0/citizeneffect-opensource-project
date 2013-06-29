class CreateUserRoleAssociations < ActiveRecord::Migration
  def self.up
    create_table :user_role_associations do |t|
      t.integer :user_id
      t.integer :role_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_role_associations
  end
end
