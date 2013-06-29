class RemoveUnusedPictureVideoAndAudioTables < ActiveRecord::Migration
  def self.up
    drop_table :project_pictures
    drop_table :project_videos
    drop_table :project_audios
  end

  def self.down
  end
end
