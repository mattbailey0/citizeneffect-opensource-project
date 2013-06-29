class MediaAlbumDisplayer < ActiveRecord::Base
  belongs_to :media_album
  belongs_to :displayer, :polymorphic => true
end
