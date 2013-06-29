class AddPublicToProjectEvent < ActiveRecord::Migration
  def self.up
    add_column :project_events, :public, :boolean
  end

  def self.down
    remove_column :project_events, :public
  end
end
