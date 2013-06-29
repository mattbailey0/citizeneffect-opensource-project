class TomsProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :is_toms_project, :boolean, :allow_nil => false, :default => false
  end

  def self.down
  end
end
