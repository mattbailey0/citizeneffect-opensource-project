class MediaAlbumsBelongToUser < ActiveRecord::Migration
  def self.up
    add_column "media_albums", :user_id, :integer
    
    MediaAlbum.reset_column_information
    MediaAlbum.all.each do |album|

      if album.project_id.nil?  #fix nil project on certain albums
        r = PartnerProjectImpactReport.find_by_media_album_id(album.id)
        album.project = r.project unless r.nil?
      end
        
      album.user = album.project.cp if album.project
      album.user = Role.citizen_effect_admin.users.first unless album.user
      
      unless album.save
        o = album
        puts <<-STR
            WARNING ========================================================
              Couldn\'t update existing #{o.class.name} ID: #{o.id}
              errors: #{o.errors.full_messages.to_sentence}
              Continuing anyway
            WARNING ========================================================
          STR
      end
    end
  end

  def self.down
  end
end
