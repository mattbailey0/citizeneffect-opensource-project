class Admin::MediaAlbumsController < AdminController

  before_filter :find_project
  before_filter :find_media_album, :except => [:index, :new, :create]
  
  def index
    @photos = @project.media_album_photos # STUB, should just be albums with only pictures
    @videos = @project.media_album_videos # STUB, is this the right method to just get videos?
  end
  
  def show
  end

  def edit
  end
  
  def update
    if(@media_album.update_attributes(params[:media_album]))
      flash[:notice] = "Media Album was successfully updated."
      redirect_to([:admin, @project, @media_album])
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @media_album.destroy
    flash[:notice] = "Media Album was successfully removed."
    
    redirect_to [:admin, @project, :media_albums]
  end
  
  private
  
  def find_project
    @project = Project.find(params[:project_id])
  end
  
  def find_media_album
    @media_album = @project.media_albums.find(params[:id])
  end
end
