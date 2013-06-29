class AddPositionToFeaturedProjects < ActiveRecord::Migration
  def self.up
    add_column :featured_projects, :position, :integer
    
    FeaturedProject.all.each_with_index do |fp, i|
      fp.position = i+1
      fp.save
    end
  end

  def self.down
    remove_column :featured_projects, :position
  end
end
