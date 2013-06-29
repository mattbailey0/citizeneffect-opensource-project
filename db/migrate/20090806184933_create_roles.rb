class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
    
    Role.create!(:name => "1well_admin", :description => "Admin for the whole system. Can pretty much do anything.")
    Role.create!(:name => "ngo_admin", :description => "Admin for one or more NGOs")
    Role.create!(:name => "cp", :description => "Helps manage projects for NGOs")
    Role.create!(:name => "basic_user", :description => "Works on various projects in the system")
  end

  def self.down
    drop_table :roles
  end
end
