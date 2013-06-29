# STUB maybe this whole thing could be a little better.  Transactions in the controllers ohnoes
class Admin::MediaAlbumPhotosController < AdminController
  before_filter :find_project_and_media_album
  
  def index
    @media_album_photos = @media_album.photos
  end
  
  def show
    @media_album_photo = @media_album.media_album_photos.find(params[:id])  
  end

  def new
    @media_album_photo = @media_album.media_album_photos.build
  end

  def edit
    @media_album_photo = @media_album.media_album_photos.find(params[:id])
  end
  
  def create
    @media_album_media = @media_album.media_album_medias.build(:media => MediaAlbumPhoto.new(params[:media_album_photo]))

    if @media_album_media.save
      flash[:notice] = "Photo was successfully added."
      redirect_to([:admin, @project, @media_album, @media_album_media.media])
    else
      render :action => "new"
    end
  end
  
  def update
    @media_album_photo = @media_album.media_album_photos.find(params[:id])
    
    if @media_album_photo.update_attributes(params[:media_album_photo])
      flash[:notice] = "Photo was successfully updated."
      redirect_to([:admin, @project, @media_album, @media_album_photo])
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @media_album_media = @media_album.media_album_medias.find_by_media_id(params[:id])
    @media_album_photo = @media_album.media_album_photos.find(params[:id])
    
    MediaAlbumMedia.transaction do
      @media_album_media.destroy
      @media_album_photo.destroy
    end
    flash[:notice] = "Photo was successfully removed."
    
    redirect_to([:admin, @project, @media_album, :media_album_photos])
  end
  
  private
  
  def find_project_and_media_album
    @project = Project.find(params[:project_id])
    @media_album = @project.media_albums.find(params[:media_album_id])
  end
end
