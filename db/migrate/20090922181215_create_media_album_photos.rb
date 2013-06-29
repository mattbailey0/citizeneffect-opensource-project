class CreateMediaAlbumPhotos < ActiveRecord::Migration
  def self.up
    create_table :media_album_photos do |t|
      t.string   :title, :default => ""
      t.text     :description
      t.owner    :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :media_album_photos
  end
end
