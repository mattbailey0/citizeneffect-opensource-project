class MediaAlbumMediasController < ApplicationController
  
  before_filter :find_project
  before_filter :require_cp_for_project, :except => [:show]
  
  def show
    @media_album_media = MediaAlbumMedia.find(params[:id])
    
  end
  
  def destroy
    @media_album_media = MediaAlbumMedia.find(params[:id])
    @media_album_media.destroy
    
    flash[:notice] = "Album deleted."

    redirect_to([:edit, @project, @media_album_media.media_album])
  end

  private
  
  def find_project
    @project = MediaAlbumMedia.find(params[:id]).media_album.project
  end
  
end
