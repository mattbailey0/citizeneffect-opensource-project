class CreateMediaAlbumVideos < ActiveRecord::Migration
  def self.up
    create_table :media_album_videos do |t|
      t.string   :title, :default => ""
      t.text     :description
      t.string   :url
      t.owner    :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :media_album_videos
  end
end
