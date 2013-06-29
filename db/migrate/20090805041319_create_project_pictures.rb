class CreateProjectPictures < ActiveRecord::Migration
  def self.up
    create_table :project_pictures do |t|
      t.integer :project_id
      t.string  :caption
      t.string  :related_project_stage
      t.string  :picture_file_name
      t.string  :picture_content_type
      t.string  :picture_file_size
      t.string  :picture_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :project_pictures
  end
end
