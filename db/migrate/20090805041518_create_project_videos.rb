class CreateProjectVideos < ActiveRecord::Migration
  def self.up
    create_table :project_videos do |t|
      t.integer :project_id
      t.string  :caption
      t.string  :related_project_stage
      t.string  :video_file_name
      t.string  :video_content_type
      t.string  :video_file_size
      t.string  :video_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :project_videos
  end
end
