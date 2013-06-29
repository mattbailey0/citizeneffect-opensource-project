class AddLngToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :lng, :float
  end

  def self.down
    remove_column :projects, :lng
  end
end
