class CreateRolePermissionAssociations < ActiveRecord::Migration
  def self.up
    create_table :role_permission_associations do |t|
      t.integer :role_id
      t.integer :permission_id
      t.timestamps
    end
    
    approve_projects = Permission.create(:name => "approve_projects", :description => "Can this user give projects the go ahead?")
    delete_projects = Permission.create(:name => "delete_projects", :description => "Can this user delete all projects in the system?")
    
    onewell_admin = Role.find_by_name("1well_admin")
    RolePermissionAssociation.create(:role_id => onewell_admin.id, :permission_id => approve_projects.id)
    RolePermissionAssociation.create(:role_id => onewell_admin.id, :permission_id => delete_projects.id)

    
  end

  def self.down
    drop_table :role_permission_associations
  end
end
