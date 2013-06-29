class AddEstimatedCloseDateToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :estimated_close_date, :date
  end

  def self.down
    remove_column :projects, :estimated_close_date
  end
end
