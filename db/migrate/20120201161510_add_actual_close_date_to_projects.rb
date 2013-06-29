class AddActualCloseDateToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :actual_close_date, :date
  end

  def self.down
    remove_column :projects, :actual_close_date
  end
end
