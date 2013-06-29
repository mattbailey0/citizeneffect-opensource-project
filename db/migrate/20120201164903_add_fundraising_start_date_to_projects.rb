class AddFundraisingStartDateToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :fundraising_start_date, :date
  end

  def self.down
    remove_column :projects, :fundraising_start_date
  end
end
