class CreateMediaAlbums < ActiveRecord::Migration
  def self.up
    create_table :media_albums do |t|
      t.string  :title
      t.integer :project_id
      t.timestamps
    end
  end

  def self.down
    drop_table :media_albums
  end
end
