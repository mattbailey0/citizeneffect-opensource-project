class AddAlbumCoverToAlbum < ActiveRecord::Migration
  def self.up
    add_column "media_albums", :album_cover_id, :integer
  end

  def self.down
    remove_column "media_albums", :album_cover_id
  end
end
