class AddEmailExemptToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :email_exempt, :tinyint
  end

  def self.down
    remove_column :projects, :email_exempt
  end
end
