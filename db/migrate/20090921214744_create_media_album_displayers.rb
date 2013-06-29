class CreateMediaAlbumDisplayers < ActiveRecord::Migration
  def self.up
    create_table :media_album_displayers do |t|
      t.integer :media_album_id
      t.integer :displayer_id
      t.string  :displayer_type
      t.timestamps
    end
  end

  def self.down
    drop_table :media_album_displayers
  end
end
