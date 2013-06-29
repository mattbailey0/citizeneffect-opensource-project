class Admin::MediaAlbumVideosController < AdminController
  before_filter :find_project_and_media_album
  
  def index
    @media_album_videos = @media_album.videos
  end
  
  def show
    @media_album_video = @media_album.media_album_videos.find(params[:id])  
  end

  def new
    @media_album_video = @media_album.media_album_videos.build
  end

  def edit
    @media_album_video = @media_album.media_album_videos.find(params[:id])
  end
  
  def create
    @media_album_media = @media_album.media_album_medias.build(:media => MediaAlbumVideo.new(params[:media_album_video]))

    if @media_album_media.save
      flash[:notice] = "Video was successfully added."
      redirect_to([:admin, @project, @media_album, @media_album_media.media])
    else
      render :action => "new"
    end
  end
  
  def update
    @media_album_video = @media_album.media_album_videos.find(params[:id])
    
    if @media_album_video.update_attributes(params[:media_album_video])
      flash[:notice] = "Video was successfully updated."
      redirect_to([:admin, @project, @media_album, @media_album_video])
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @media_album_media = @media_album.media_album_medias.find_by_media_id(params[:id])
    @media_album_video = @media_album.media_album_videos.find(params[:id])
    
    MediaAlbumMedia.transaction do
      @media_album_media.destroy
      @media_album_video.destroy
    end
    flash[:notice] = "Video was successfully removed."
    
    redirect_to([:admin, @project, @media_album, :media_album_videos])
  end
  
  private
  
  def find_project_and_media_album
    @project = Project.find(params[:project_id])
    @media_album = @project.media_albums.find(params[:media_album_id])
  end
end
