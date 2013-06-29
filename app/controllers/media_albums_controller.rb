class MediaAlbumsController < ApplicationController
  
  before_filter :find_project
  before_filter :require_cp_for_project, :except => [:index]
  
  def index
    @photo_albums = @project.media_albums # STUB, should just be albums with only pictures
    @videos = @project.media_album_videos # STUB, is this the right method to just get videos?
  end
  
  def new
    @media_album = @project.media_albums.build(params[:media_album])
    render :action => "edit"
  end
  
  def edit
    @media_album = @project.media_albums.find(params[:id])
  end

  def create
    @media_album = @project.media_albums.build(params[:media_album])
    @media_album.user = current_user

    respond_to do |format|
      if @media_album.save
        flash[:notice] = 'MediaAlbum was successfully updated.'
        format.html { redirect_to([:edit, @project, @media_album]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @media_album.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @media_album = @project.media_albums.find(params[:id])

    respond_to do |format|
      if @media_album.update_attributes(params[:media_album])
        flash[:notice] = 'Media Album was successfully updated.'
        format.html { redirect_to([:edit, @project, @media_album]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @media_album.errors, :status => :unprocessable_entity }
      end
    end
  end

  def sort
    @media_album = @project.media_albums.find(params[:id])
    @media_album_medias = @media_album.media_album_medias.each do |mam|
      mam.position = params['media_album_medias'].index(mam.id.to_s) + 1
      mam.save
    end
    render :nothing => true
  end
  
  def destroy
    @media_album = @project.media_albums.find(params[:id])
    @media_album.destroy
    
    flash[:notice] = "Album deleted."

    redirect_to([:new, @project, :media_album])
  end

  private
  
  def find_project
#     @project = Project.find(params[:project_id]) if params[:project_id]
    
    @project = Project.find(params[:project_id])
    unless current_user_can_edit_public_project?
      @project = Project.user_visible_projects.find(params[:project_id])
    end
    
  end
  
end
