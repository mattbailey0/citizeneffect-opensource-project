class CreateMediaAlbumMedias < ActiveRecord::Migration
  def self.up
    create_table :media_album_medias do |t|
      t.integer  :media_album_id
      t.integer  :position
      t.integer  :media_id
      t.string   :media_type
      t.timestamps
    end
  end

  def self.down
    drop_table :media_album_medias
  end
end
