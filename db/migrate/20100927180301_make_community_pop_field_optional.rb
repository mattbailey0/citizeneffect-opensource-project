class MakeCommunityPopFieldOptional < ActiveRecord::Migration
  def self.up
    add_column :projects, :community_population_required, :boolean, :default => true, :allow_nil => false
  end

  def self.down
  end
end
