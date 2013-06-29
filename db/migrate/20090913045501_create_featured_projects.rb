class CreateFeaturedProjects < ActiveRecord::Migration
  def self.up
    create_table :featured_projects do |t|
      t.string :title
      t.string :caption
      t.string :url_identifier
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :featured_projects
  end
end
