class AddLatToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :lat, :float
  end

  def self.down
    remove_column :projects, :lat
  end
end
